//! Headless scenario runner for mod tests (driven by `bbtest.py` in the user's mods repo).
//!
//! ```text
//! bbtest --data DIR --out events.log [--logs DIR] [--saves DIR] [--mod a.zip]...
//!        [--script file.nut]... [--mode menu|campaign] [--seed S] [--origin scenario.x]
//!        [--timeout SECS] [--fps 60] [--max-frames N] [--load SAVE | --snapshot SAVE]
//! ```
//!
//! Mounts only the `data_*.dat` of `--data` plus the given mod zips, boots the main menu,
//! runs every `--script` there (each compiled on its own, with the game's f32 math), then,
//! in campaign mode, starts a campaign through the menu (`::BBTest.newCampaign()` /
//! `::BBTest.startCampaign()`), runs past the origin's intro and calls
//! `::BBTest.onCampaignStarted()`. `--load SAVE` loads that save through the main menu instead
//! of starting a campaign; `--snapshot SAVE` saves the campaign as started (paused, past the
//! intro). Then `::BBTest.start()` and frames until `::BBTest.Finished`, calling
//! `::BBTest.tick()` after each (and `::BBTest.tickFailed(msg)` when it raises).
//!
//! Every log row goes to `--out` as `ROW <class> <tag> <text>`, every uncaught script
//! error as `SCRIPT_ERROR <message>` followed by `  at` lines; runner lines start with
//! `RUNNER`. Exit codes: 0 the scripts finished, 2 a script failed to load or the game to
//! boot, 3 a frame failed, 124 timeout.

use std::io::Write;
use std::path::PathBuf;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

use bb_engine::{harness, tactical_player};
use squirrel::ErrorValue;
use squirrel_bb::html_log;

const IN_WORLD: &str = "(\"State\" in ::World) && ::World.State != null && ::World.State.getPlayer() != null && !::LoadingScreen.isVisible()";
const MSU_SETTINGS: &str = "(\"MSU\" in ::getroottable()) && ::MSU.SettingsScreen.isVisible()";

struct Options {
	data: PathBuf,
	out: PathBuf,
	logs: Option<PathBuf>,
	saves: Option<PathBuf>,
	mods: Vec<PathBuf>,
	scripts: Vec<PathBuf>,
	campaign: bool,
	seed: String,
	origin: String,
	timeout: f64,
	fps: f64,
	max_frames: u64,
	load: Option<String>,
	snapshot: Option<String>,
}

fn options() -> Result<Options, String> {
	let mut o = Options {
		data: PathBuf::from(harness::STEAM_DATA_DIR),
		out: PathBuf::new(),
		logs: None,
		saves: None,
		mods: Vec::new(),
		scripts: Vec::new(),
		campaign: false,
		seed: "bbtest".into(),
		origin: "scenario.early_access".into(),
		timeout: 300.0,
		fps: 60.0,
		max_frames: 2_000_000,
		load: None,
		snapshot: None,
	};
	let mut args = std::env::args().skip(1);
	while let Some(a) = args.next() {
		let mut v = || args.next().ok_or(format!("{a} needs a value"));
		match a.as_str() {
			"--data" => o.data = v()?.into(),
			"--out" => o.out = v()?.into(),
			"--logs" => o.logs = Some(v()?.into()),
			"--saves" => o.saves = Some(v()?.into()),
			"--mod" => o.mods.push(v()?.into()),
			"--script" => o.scripts.push(v()?.into()),
			"--mode" => {
				o.campaign = match v()?.as_str() {
					"menu" => false,
					"campaign" => true,
					m => return Err(format!("unknown mode {m}")),
				}
			}
			"--seed" => o.seed = v()?,
			"--origin" => o.origin = v()?,
			"--timeout" => o.timeout = v()?.parse().map_err(|e| format!("--timeout: {e}"))?,
			"--fps" => o.fps = v()?.parse().map_err(|e| format!("--fps: {e}"))?,
			"--max-frames" => o.max_frames = v()?.parse().map_err(|e| format!("--max-frames: {e}"))?,
			"--load" => o.load = Some(v()?),
			"--snapshot" => o.snapshot = Some(v()?),
			_ => return Err(format!("unknown argument {a}")),
		}
	}
	if o.out.as_os_str().is_empty() {
		return Err("--out <file> is required".into());
	}
	Ok(o)
}

type Out = Arc<Mutex<std::fs::File>>;

fn say(out: &Out, s: &str) {
	let _ = writeln!(out.lock().unwrap(), "{s}");
}

/// A row's text on one line: the log's `<br>` stays as is.
fn one_line(s: &str) -> String {
	s.replace('\n', "<br>").replace('\r', "")
}

fn main() -> std::process::ExitCode {
	let o = match options() {
		Ok(o) => o,
		Err(e) => {
			eprintln!("{e}");
			return std::process::ExitCode::from(2);
		}
	};
	let out: Out = Arc::new(Mutex::new(std::fs::File::create(&o.out).expect("create --out")));
	let timed_out = Arc::new(AtomicBool::new(false));
	let code = match run(&o, &out, &timed_out) {
		Ok(()) => 0,
		Err((code, e)) => {
			say(&out, &format!("RUNNER STOPPED {}", one_line(&e)));
			code
		}
	};
	let code = if timed_out.load(Ordering::Relaxed) { 124 } else { code };
	say(&out, &format!("RUNNER EXIT {code}"));
	html_log::close();
	// Skip the engine's teardown: a run's state is thrown away anyway.
	std::process::exit(code.into())
}

fn run(o: &Options, out: &Out, timed_out: &Arc<AtomicBool>) -> Result<(), (u8, String)> {
	let started = Instant::now();
	let boot = |e: String| (2u8, e);
	let io = |e: std::io::Error| (2u8, e.to_string());
	let mut archives = harness::data_archives(&o.data).map_err(io)?;
	for m in &o.mods {
		say(out, &format!("RUNNER MOD {}", m.display()));
	}
	archives.extend(o.mods.iter().cloned());
	if let Some(logs) = &o.logs {
		std::fs::create_dir_all(logs).map_err(io)?;
		html_log::open(&logs.join("log.html"), "bbtest").map_err(io)?;
	}
	{
		let out = out.clone();
		html_log::set_tap(Some(Box::new(move |class: html_log::Class, tag: &str, text: &[u8]| {
			let text = one_line(&String::from_utf8_lossy(text));
			say(&out, &format!("ROW {} {} {}", class.name(), if tag.is_empty() { "-" } else { tag }, text));
		})));
	}
	let mut engine = harness::open_mounted(&o.data, archives, |_| {}).map_err(io)?;
	if let Some(saves) = &o.saves {
		std::fs::create_dir_all(saves).map_err(io)?;
		engine.saves().set_directory(saves.clone());
	}
	engine.saves().set_modified(!o.mods.is_empty());
	{
		let out = out.clone();
		engine.vm_mut().set_runtime_error_handler(move |error| {
			html_log::script_error(error);
			let message = match &error.error {
				ErrorValue::String(b) => String::from_utf8_lossy(b).into_owned(),
				other => format!("(a thrown {other:?})"),
			};
			let mut s = format!("SCRIPT_ERROR {}", one_line(&message));
			for f in &error.frames {
				s += &format!(
					"\n  at {} ({}:{})",
					f.function.as_deref().unwrap_or("?"),
					f.source.as_deref().unwrap_or("?"),
					f.line
				);
				if !f.locals.is_empty() {
					let locals: Vec<String> = f
						.locals
						.iter()
						.take(10)
						.map(|l| {
							let v: String = String::from_utf8_lossy(&html_log::value::local(&l.value)).chars().take(60).collect();
							format!("{}={}", l.name, one_line(&v))
						})
						.collect();
					s += &format!("\n     {}", locals.join(", "));
				}
			}
			say(&out, &s);
		});
	}
	// Watchdog: interrupt the scripts at their next native call, then give up.
	{
		let (out, timed_out) = (out.clone(), timed_out.clone());
		let interrupter = engine.vm().interrupter();
		let limit = Duration::from_secs_f64(o.timeout);
		std::thread::spawn(move || {
			std::thread::sleep(limit);
			say(&out, &format!("RUNNER TIMEOUT after {limit:.0?}"));
			timed_out.store(true, Ordering::Relaxed);
			interrupter.request();
			std::thread::sleep(Duration::from_secs(10));
			say(&out, "RUNNER TIMEOUT scripts didn't stop within 10 s, exiting");
			say(&out, "RUNNER EXIT 124");
			std::process::exit(124);
		});
	}
	let frame_ms = 1000.0 / o.fps;
	let step = || -> Result<(), (u8, String)> {
		if timed_out.load(Ordering::Relaxed) {
			return Err((124, "timed out".into()));
		}
		harness::run_frame(&engine, frame_ms).map_err(|e| (3, e))
	};
	let eval = |expr: &str| tactical_player::eval_i64(&engine, &format!("({expr}) ? 1 : 0")).ok().flatten() == Some(1);
	let script = |src: &str, name: &str| engine.run_script(src, name).map_err(|e| (3u8, format!("{name}: {e}")));
	let mark = |what: &str| say(out, &format!("RUNNER TIME {what} {:.3}", started.elapsed().as_secs_f64()));

	harness::boot_menu(&engine).map_err(boot)?;
	harness::install_autoplay(&engine).map_err(boot)?;
	for _ in 0..30 {
		step()?;
	}
	mark("menu");
	for path in &o.scripts {
		let src = std::fs::read_to_string(path).map_err(|e| (2, format!("{}: {e}", path.display())))?;
		let name = path.to_string_lossy();
		let vm = engine.vm();
		match vm.compile_capturing(&src, &name) {
			Ok(closure) => {
				closure.set_f32_math(vm, true);
				if let Err(e) = closure.call(vm, ()) {
					say(out, &format!("RUNNER SCRIPT_FAILED {name}: {}", one_line(&e.to_string())));
				}
			}
			Err(e) => say(out, &format!("RUNNER COMPILE_ERROR {}:{}:{} {}", e.source, e.line, e.column, one_line(&e.message))),
		}
	}
	if let (true, Some(save)) = (o.campaign, &o.load) {
		script("::BBTest.runBeforeCampaign();", "beforeCampaign")?;
		// world_state ignores a load within 4 s of real time after the last one, the game's start included.
		for _ in 0..600 {
			if eval("::Time.getRealTimeF() > 4.1") {
				break;
			}
			step()?;
		}
		script(&format!("::RootState.get(\"MainMenuState\").campaign_menu_module_onLoadPressed({save:?});"), "load")?;
		let mut in_world = false;
		for _ in 0..6000 {
			if eval(IN_WORLD) {
				in_world = true;
				break;
			}
			step()?;
		}
		if !in_world {
			return Err((2, format!("{save} didn't load in 6000 frames")));
		}
		mark("campaign");
		script("::World.State.setPause(true); ::BBTest.onCampaignStarted();", "campaign loaded")?;
	} else if o.campaign {
		script("::BBTest.runBeforeCampaign();", "beforeCampaign")?;
		script("::BBTest.newCampaign();", "new campaign")?;
		step()?;
		script(
			&format!("::BBTest.startCampaign({:?}, {:?});", o.seed, o.origin),
			"start campaign",
		)?;
		let mut in_world = false;
		for _ in 0..6000 {
			if eval(IN_WORLD) {
				in_world = true;
				break;
			}
			if eval(MSU_SETTINGS) {
				script("::MSU.SettingsScreen.onSaveButtonPressed({});", "MSU settings")?;
			}
			step()?;
		}
		if !in_world {
			return Err((2, "the campaign didn't start in 6000 frames".into()));
		}
		// Past the origin's intro event (shown 1 s of real time in), answered by the
		// autoplay. Not harness::run_past_intro: mods keep real-time events pending.
		for i in 0..600 {
			if i >= 90 && !eval("::World.State.getEventScreen().isVisible()") {
				break;
			}
			step()?;
		}
		mark("campaign");
		if let Some(save) = &o.snapshot {
			script(&format!("::World.State.setPause(true); ::World.State.saveCampaign({save:?});"), "snapshot")?;
		}
		script("::BBTest.onCampaignStarted();", "campaign started")?;
	}
	script("::BBTest.start();", "start")?;
	let mut frames = 0u64;
	while !eval("::BBTest.Finished") {
		if frames >= o.max_frames {
			return Err((124, format!("not finished after {frames} frames")));
		}
		step()?;
		frames += 1;
		// Outside any try, so a test's error reaches the error handler with its stack.
		if let Err(e) = engine.run_script("::BBTest.tick();", "tick") {
			script(&format!("::BBTest.tickFailed({:?});", one_line(&e)), "tick failed")?;
		}
	}
	mark("done");
	say(out, &format!("RUNNER FRAMES {frames}"));
	Ok(())
}
