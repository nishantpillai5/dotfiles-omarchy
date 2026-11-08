# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
export LIBVIRT_URI=qemu:///system

. "$HOME/.local/share/../bin/env"

# --- user section (ported from old zsh setup, 2026-11) ---

# vi-mode
set -o vi
# jk exits insert mode -> command mode (like oh-my-zsh vi-mode)
bind -m vi-insert '"jk": vi-movement-mode'

# git aliases (from old oh-my-zsh git plugin)
# NOTE: ga/gd are Omarchy worktree functions (add/drop worktree) — don't alias over them
alias gst='git status'
alias gc='git commit'
alias gco='git checkout'
alias gp='git pull'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gf='git fetch'
alias gaa='git add -A'
alias gca='git commit --amend'

# yazi file picker: cd into the directory you exit in (ported from old oh-my-zsh tools.zsh)
function f() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

# fastfetch in new tmux window (ported from old oh-my-zsh tools.zsh)
if command -v fastfetch &> /dev/null; then
  if [[ -z "$NVIM" ]] && [[ -n "$TMUX" ]] && [[ "$(tmux display-message -p '#P')" == 1 ]]; then
    fastfetch
  fi
fi

# terminal clear (override stock `c='opencode --auto'` — not used)
alias c='clear'
alias cls='clear'

# TUI tools
alias ld='lazydocker'
alias lg='lazygit'
alias ly='yadm enter lazygit'

# yadm (dotfiles VCS)
alias y='yadm'
alias ya='yadm add'
alias yst='yadm status'
alias yc='yadm commit'
alias yd='yadm diff'
alias ylgg='yadm log --graph'
alias ylg='yadm log --stat'
alias yl='yadm pull'
alias yp='yadm push'

# activate virtual environment
alias act='source .venv/bin/activate'

# devpod (v0.6.15 in ~/.local/bin; `up` works but is deprecated in favor of `start`)
alias dpup='devpod up . --provider docker --dotfiles https://github.com/nishantpillai5/dotfiles.git --ide none'
alias dpin='devpod ssh .'

# directory shortcuts (adapted: work dir is ~/Work here)
alias ww='cd ~/Work'
alias nn='cd ~/notes'

alias -- '.....'='cd ../../../..'
alias -- '......'='cd ../../../../..'
alias -- 'p'='pushd'
alias -- 'pd'='popd'
alias grep='grep --color=auto'

# aa [claude|pi]: workmux dashboard on the left, a coordinator session on the right.
# (ported from old oh-my-zsh tools.zsh) Without an argument the agent is $WM_AGENT,
# else Omarchy's default agent, else claude.
aa() {
  local agent start
  agent=${1:-$(wm-agent default)} || return 1
  case $agent in
    claude) start="claude /coordinator" ;;
    pi) start="pi /skill:coordinator" ;;
    *)
      echo "aa: unknown agent '$agent' (want claude or pi)" >&2
      return 1
      ;;
  esac
  if [[ -z $TMUX ]]; then
    echo "aa: run inside tmux" >&2
    return 1
  fi
  command tmux rename-window -t "$TMUX_PANE" coordinator
  local right
  right=$(command tmux split-window -h -t "$TMUX_PANE" -c "$PWD" -P -F '#{pane_id}')
  command tmux send-keys -t "$right" "$start" Enter
  workmux dashboard
}

# direnv (installed via mise; hook goes after mise env so the shim is on PATH)
if command -v direnv &> /dev/null; then
  eval "$(direnv hook bash)"
fi
