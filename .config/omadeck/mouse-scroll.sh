#!/bin/sh
# Scroll the focused window like a mouse wheel.
#
# ydotool wheel events go to the window under the cursor, not the focused
# window, so when the cursor is elsewhere the script parks it over the
# focused window's centre, wheels, and puts it back.
dir=${1:-down}

info=$(hyprctl activewindow 2>/dev/null) || exit 0
at=$(printf '%s\n' "$info" | awk '/at:/{print $2; exit}')
size=$(printf '%s\n' "$info" | awk '/size:/{print $2; exit}')
[ -n "$at" ] && [ -n "$size" ] || exit 0
wx=${at%%,*}; wy=${at##*,}
ww=${size%%,*}; wh=${size##*,}

cur=$(hyprctl cursorpos 2>/dev/null)
cx=${cur%%,*}; cy=$(printf '%s' "${cur##*,}" | tr -d ' ')
case "$cx$cy" in '' | *[!0-9-]*) exit 0 ;; esac

# Half a wheel notch per detent; bump to 120 for a full one.
if [ "$dir" = up ]; then wheel=60; else wheel=-60; fi

# Cursor already over the focused window: just wheel.
if [ "$cx" -ge "$wx" ] && [ "$cx" -lt $((wx + ww)) ] &&
   [ "$cy" -ge "$wy" ] && [ "$cy" -lt $((wy + wh)) ]; then
    ydotool mousemove -w -- 0 "$wheel"
    exit 0
fi

# Otherwise: calibrate ydotool's absolute coordinate scale with a probe at
# the top-left corner (where it cannot clamp), park over the window, wheel,
# and restore the cursor.
ydotool mousemove -a -- 400 400
sleep 0.3
p=$(hyprctl cursorpos 2>/dev/null)
px=${p%%,*}; py=$(printf '%s' "${p##*,}" | tr -d ' ')

scale_req() {
    awk -v tx="$1" -v ty="$2" -v px="$px" -v py="$py" 'BEGIN {
        if (px < 100 || py < 100) { printf "%d %d", tx, ty }
        else { printf "%d %d", tx / (px / 400), ty / (py / 400) }
    }'
}

ydotool mousemove -a -- $(scale_req $((wx + ww / 2)) $((wy + wh / 2)))
sleep 0.3
ydotool mousemove -w -- 0 "$wheel"
ydotool mousemove -a -- $(scale_req "$cx" "$cy")
