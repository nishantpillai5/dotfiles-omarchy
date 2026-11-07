#!/usr/bin/env bash
# Stop a running pi session: find the tmux pane hosting the pi process and
# send Ctrl+X, which is bound to pi's app.interrupt in ~/.pi/agent/keybindings.json.
#
# Why not ydotool: it injects into the globally focused window and its
# keycode:state syntax is easy to get wrong. tmux send-keys targets the
# exact pane and delivers the raw byte straight to pi's pty.
set -euo pipefail

pi_pid=$(pgrep -x pi | head -1) || { echo "stop-pi: no pi process running" >&2; exit 1; }

# $1 = candidate ancestor, $2 = descendant. True if $1 is in $2's parent chain.
is_ancestor() {
  local p=$2
  while [ -n "$p" ] && [ "$p" != "0" ] && [ "$p" != "1" ]; do
    [ "$p" = "$1" ] && return 0
    p=$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ') || return 1
  done
  return 1
}

target=$(
  tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_pid}' |
  while read -r t pid; do
    if is_ancestor "$pid" "$pi_pid"; then
      echo "$t"
      break
    fi
  done
)

[ -n "$target" ] || { echo "stop-pi: pi (pid $pi_pid) not in any tmux pane" >&2; exit 1; }

tmux send-keys -t "$target" C-x
