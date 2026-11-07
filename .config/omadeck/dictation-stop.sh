#!/bin/sh
# Stop dictation, wait for the transcription to finish, then press Enter so
# the typed line goes through. A no-op when idle, so a stray release (or a
# second commit) never types anything.
case "$(voxtype status 2>/dev/null)" in
    idle) exit 0 ;;
esac
voxtype record stop
for _ in $(seq 1 240); do
    [ "$(voxtype status 2>/dev/null)" = "idle" ] && break
    sleep 0.25
done
wtype -k Return
