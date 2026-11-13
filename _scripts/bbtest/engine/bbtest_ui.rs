//! `bbtest` with the game's real UI page: the same scenario runner (see `bbtest.rs`, driven
//! by `bbtest.py --ui-page` in the user's mods repo), with the install's and mods' `ui/`
//! running in Chromium instead of the engine's stub UI client. Headless: no display, no
//! GPU (`HostConfig::headless`, software compositing into memory), frames as fast as they
//! run.
//!
//! The page's clock follows the game's: after the menu boots, each frame's time advances
//! the page's timers, animation frames, `performance.now()` and `Date.now()`
//! (`virtual_time.js`), so a timer of 500 ms fires 30 frames later however fast frames
//! run. CSS animations and transitions stay on Chromium's real clock; page frames (paints,
//! CSS animation steps) begin at most `BBTEST_UI_FPS` (default 30) times a real second.
//!
//! Scripts get `::BBTest_js(code)` (evaluates JS in the page, returns `{v = value}`; a JS
//! exception raises) and `::BBTest_shot(name)` (a PNG of the page, `<logs>/<name>.png`). Page errors
//! (`console.error`, uncaught exceptions) reach the log as `ROW error UI ...`.
//!
//! ```text
//! bbtest_ui <bbtest's arguments>
//! ```

use std::io::Write;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

use bb_engine::{harness, tactical_player};
use bb_ui::host::{Echo, HostConfig, PageFrames, UiSession};
use bb_ui::json::Json;
use squirrel::{ErrorValue, SQVM, SqArray, SqRef, SqStrongRef, SqTable};
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

fn one_line(s: &str) -> String {
	s.replace('\n', "<br>").replace('\r', "")
}

fn main() -> std::process::ExitCode {
	// Chromium runs this binary again for its child processes.
	if let Some(code) = bb_ui::host::run_subprocess() {
		std::process::exit(code);
	}
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
	// Chromium's processes go with this one (no teardown: a run's state is thrown away).
	std::process::exit(code.into())
}

/// A JS value as Squirrel's: numbers keep their fractions.
fn to_sq<'vm>(vm: &'vm SQVM, json: &Json) -> SqRef<'vm> {
	match json {
		Json::Null => SqRef::Null,
		Json::Bool(b) => SqRef::Bool(*b),
		Json::Int(n) => SqRef::Integer(*n),
		Json::Float(f) if f.fract() == 0.0 && f.abs() < 9e15 => SqRef::Integer(*f as i64),
		Json::Float(f) => SqRef::Float(*f),
		Json::Str(s) => SqRef::String(s.clone()),
		Json::Array(items) => {
			let mut array = SqArray::new(vm);
			for item in items {
				array.push(to_sq(vm, item));
			}
			SqRef::Array(array)
		}
		Json::Object(entries) => {
			let mut table = SqTable::new(vm);
			for (key, value) in entries {
				table.set(key.as_str(), to_sq(vm, value));
			}
			SqRef::Table(table)
		}
	}
}

/// Let the page paint what changed (page frames for 200 ms of real time), then save the
/// latest paint as a PNG.
fn screenshot(session: &UiSession, path: &Path) -> Result<(), String> {
	session.pump_until(Duration::from_millis(200), |s| {
		s.host().begin_frame();
		false
	});
	match session.screenshot(path)? {
		Some(_) => Ok(()),
		None => Err("the page never painted".into()),
	}
}

fn run(o: &Options, out: &Out, timed_out: &Arc<AtomicBool>) -> Result<(), (u8, String)> {
	let started = Instant::now();
	let boot = |e: String| (2u8, e);
	let io = |e: std::io::Error| (2u8, e.to_string());
	for m in &o.mods {
		say(out, &format!("RUNNER MOD {}", m.display()));
	}
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
	let config = HostConfig {
		headless: true,
		frames: PageFrames::Game { waiting_rate: 60 },
		extra_mods: o.mods.clone(),
		cef_log: o.logs.as_ref().map(|l| l.join("cef.log")),
		..HostConfig::default()
	};
	// Boxed: the natives below hold its address.
	let mut session = Box::new(UiSession::open(&o.data, config, Echo::Off).map_err(boot)?);
	mark_time(out, started, "page opened");
	let page: *const UiSession = &*session;
	let engine = session.engine_mut();
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
	// SAFETY: the session is boxed and lives until the process exits; the natives run on
	// this thread, inside its scripts.
	let page = move || unsafe { &*page };
	engine.vm_mut().register("BBTest_js", move |vm: &SQVM, code: String| -> Result<SqStrongRef, String> {
		let value = page().eval(&code)?;
		let mut result = SqTable::new(vm);
		result.set("v", to_sq(vm, &value));
		Ok(result.to_strong())
	});
	let shots = o.logs.clone().unwrap_or_else(|| PathBuf::from("."));
	engine.vm_mut().register("BBTest_shot", move |name: String| -> Result<String, String> {
		let path = shots.join(format!("{name}.png"));
		screenshot(page(), &path)?;
		Ok(path.to_string_lossy().into_owned())
	});
	let session = &*session;
	let engine = session.engine();
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
	let page_frame = Duration::from_secs_f64(1.0 / std::env::var("BBTEST_UI_FPS").ok().and_then(|v| v.parse().ok()).unwrap_or(30.0));
	// The game's time (ms), and when the page's next timer is due on it; none before the
	// page goes on the game's clock.
	let clock = std::cell::Cell::new((0.0f64, f64::INFINITY));
	let page_clock = std::cell::Cell::new(false);
	let clock_calls = std::cell::Cell::new(0u64);
	let last_page_frame = std::cell::Cell::new(Instant::now());
	// A game frame, the page's timers due by its time, then the scripted player (the page
	// parked: scripts may run).
	let step = || -> Result<(), (u8, String)> {
		if timed_out.load(Ordering::Relaxed) {
			return Err((124, "timed out".into()));
		}
		session.step_unparked(frame_ms).map_err(|e| (3, e))?;
		let (now, due) = clock.get();
		let now = now + frame_ms;
		let mut due = due;
		session.park();
		// A page that didn't rest may have set timers since the last call.
		if page_clock.get() && (now >= due || !session.host().is_resting()) {
			clock_calls.set(clock_calls.get() + 1);
			let reply = session.eval(&format!("__bbClock({now})")).map_err(|e| (3, format!("the page's clock: {e}")))?;
			let number = |i: usize| reply.as_array().and_then(|a| a.get(i)).and_then(|v| v.as_f64()).unwrap_or(-1.0);
			due = if number(0) >= 0.0 { number(0) } else { f64::INFINITY };
			// Pictures load in real time: wait for them here, so their load events land in
			// this frame however fast frames run.
			if number(1) > 0.0 {
				session.pump_until(Duration::from_secs(2), |s| s.eval("__bbPictures()").ok().and_then(|n| n.as_f64()) == Some(0.0));
			}
		}
		clock.set((now, due));
		// The scripted player (harness::install_autoplay), as harness::run_frame runs it.
		if let Some(autoplay) = SqTable::root(engine.vm()).get::<SqStrongRef>("__autoplay") {
			autoplay.call(engine.vm(), ()).map_err(|e| (3, format!("autoplay: {e}")))?;
		}
		if last_page_frame.get().elapsed() >= page_frame {
			session.host().begin_frame();
			last_page_frame.set(Instant::now());
		}
		Ok(())
	};
	let eval = |expr: &str| tactical_player::eval_i64(engine, &format!("({expr}) ? 1 : 0")).ok().flatten() == Some(1);
	let script = |src: &str, name: &str| engine.run_script(src, name).map_err(|e| (3u8, format!("{name}: {e}")));
	let mark = |what: &str| mark_time(out, started, what);

	session.boot_menu().map_err(boot)?;
	harness::install_autoplay(engine).map_err(boot)?;
	// From here the page runs on the game's clock.
	page_clock.set(true);
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
		script(&format!("::BBTest.startCampaign({:?}, {:?});", o.seed, o.origin), "start campaign")?;
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
			// What the page showed then.
			let _ = screenshot(session, &o.logs.clone().unwrap_or_default().join("campaign_failure.png"));
			return Err((2, "the campaign didn't start in 6000 frames".into()));
		}
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
		if let Err(e) = engine.run_script("::BBTest.tick();", "tick") {
			script(&format!("::BBTest.tickFailed({:?});", one_line(&e)), "tick failed")?;
		}
	}
	mark("done");
	say(out, &format!("RUNNER FRAMES {frames}"));
	say(out, &format!("RUNNER PAGE clock calls {}, rested frames {}, paints {}", clock_calls.get(), session.host().rested_frames(), session.host().paints()));
	Ok(())
}

fn mark_time(out: &Out, started: Instant, what: &str) {
	say(out, &format!("RUNNER TIME {what} {:.3}", started.elapsed().as_secs_f64()));
}
