#!/bin/sh
# Close the current tmux window, unless it is the last one — killing that
# would end the whole session.
n=$(tmux list-windows 2>/dev/null | wc -l)
[ "$n" -gt 1 ] && tmux kill-window
