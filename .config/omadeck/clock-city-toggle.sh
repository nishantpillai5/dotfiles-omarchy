#!/bin/sh
# Flip the clock key's city between Stockholm and Delhi.
f=~/.config/omadeck/clock-city
if [ "$(cat "$f" 2>/dev/null)" = "Delhi" ]; then
    echo Stockholm > "$f"
else
    echo Delhi > "$f"
fi
