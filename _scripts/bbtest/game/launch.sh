#!/bin/bash
# One launch of the original game, headless: a KWin of its own on a virtual output (nothing on any screen)
# runs session.sh. Env as session.sh's. The game's PIDs must stay the host's: Steam tracks them (README).
# Exits when the game does; killing this kills the whole tree (bwrap --die-with-parent).
W="$(dirname "$BBGAME_OUT")"
# Watching a launch: the game in a window on the user's display, still silent.
[ -n "$BBGAME_SHOW" ] && exec "$(dirname "$(readlink -f "$0")")/session.sh"
mkdir -p "$W/kwin"
# Silent: no sound devices or sound servers inside.
R="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
# KWin sees only the Intel GPU (see ../../bbui/kwin.sh); own bus, config and ksycoca, so it leaves the desktop's alone.
exec bwrap --dev-bind / / --die-with-parent --tmpfs /tmp/.X11-unix \
    --tmpfs /dev/snd --tmpfs "$R/pulse" --ro-bind /dev/null "$R/pipewire-0" --ro-bind /dev/null "$R/pipewire-0-manager" \
    --tmpfs /dev/dri --dev-bind /dev/dri/card1 /dev/dri/card1 --dev-bind /dev/dri/renderD128 /dev/dri/renderD128 \
    env -u DISPLAY -u WAYLAND_DISPLAY -u PULSE_SERVER -u PIPEWIRE_REMOTE KWIN_COMPOSE=O2 XDG_CONFIG_HOME="$W/kwin" KDESYCOCA="$W/kwin/ksycoca" \
    dbus-run-session kwin_wayland --virtual --no-lockscreen --socket "bbgame-$BBGAME_DISPLAY" \
    --width 1280 --height 720 --exit-with-session "$(dirname "$(readlink -f "$0")")/session.sh" > "$BBGAME_OUT.kwin" 2>&1
