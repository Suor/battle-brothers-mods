#!/bin/bash
# The KWin session (launch.sh): an Xwayland of its own, the original game in it under Proton.
# Env: BBGAME_PFX (compat data dir), BBGAME_INSTALL (the install mirror), BBGAME_OUT (output file),
# BBGAME_DISPLAY (an X display number free on this machine); BBGAME_SHOW=1: on the user's own display instead.
P="$HOME/.local/share/Steam/steamapps/common/${BBGAME_PROTON:-Proton - Experimental}"
if [ -z "$BBGAME_SHOW" ]; then
    # No abstract socket: the host (the Steam client among others) must not reach this display.
    Xwayland ":$BBGAME_DISPLAY" -nolisten local -geometry 1280x720 -noreset > "$BBGAME_OUT.xwayland" 2>&1 &
    for _ in $(seq 100); do [ -e "/tmp/.X11-unix/X$BBGAME_DISPLAY" ] && break; sleep 0.05; done
    export DISPLAY=":$BBGAME_DISPLAY"
    unset XAUTHORITY
    export __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
fi
export STEAM_COMPAT_DATA_PATH="$BBGAME_PFX"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam"
export SteamAppId=365360 SteamGameId=365360
# Frames uncapped: runner.nut keeps the virtual clock at 60 fps worth a frame.
export vblank_mode=0
export WINEDLLOVERRIDES="winepulse.drv=d;winealsa.drv=d;wineoss.drv=d"
# No gamepad accessibility helper: nothing reads this display.
export PROTON_USE_XALIA=0
export WINEDEBUG="${WINEDEBUG:--all}"
cd "$BBGAME_INSTALL/win32"
[ -n "$BBGAME_SHOTS" ] && (i=0; while sleep "$BBGAME_SHOTS"; do import -window root "$BBGAME_OUT.shot$((i++)).png"; done) &
"$P/proton" waitforexitandrun "$BBGAME_INSTALL/win32/BattleBrothers.exe" > "$BBGAME_OUT" 2>&1
kill $(jobs -p) 2>/dev/null
exit 0
