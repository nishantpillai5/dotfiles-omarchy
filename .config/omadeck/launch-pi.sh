#!/usr/bin/env bash
# Launch pi in a new tmux window. If a pi is already running inside tmux,
# focus the window hosting it instead of opening a second one.
#
# Uses the full shim path: the tmux server's environment may predate the
# current mise setup, and its PATH is whatever the server inherited at start.
set -euo pipefail

PI=/home/noobaf/.local/bin/pi

pi_pid=$(pgrep -x pi | head -1) || pi_pid=""

if [ -n "$pi_pid" ]; then
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

  if [ -n "$target" ]; then
    # Focus the window (not just the pane: pi owns the whole window).
    tmux select-window -t "${target%%.*}"
    exit 0
  fi
fi

tmux new-window "$PI"
