#!/bin/sh
# Tap-safe dictation toggle: start when idle; when recording, stop, wait for the
# transcription, then press Enter so the typed line goes through (dictation-stop.sh).
if [ "$(voxtype status 2>/dev/null)" = "recording" ]; then
    exec "$(dirname "$0")/dictation-stop.sh"
else
    voxtype record start
fi
