#!/usr/bin/env bash
# Bootstrap a fresh Omarchy (Arch) machine with this dotfiles repo.
#
# Usage on a new machine:
#   sudo pacman -S --needed git
#   git clone https://github.com/nishantpillai5/dotfiles-omarchy.git ~/dotfiles
#   ~/dotfiles/bootstrap.sh
#
# What it does:
#   1. Installs the pacman tools the setup depends on
#   2. Creates + bootstraps yadm from this repo (configs land in $HOME)
#   3. Installs mise-managed tools (yazi, fastfetch, direnv — pinned in
#      .config/mise/config.toml)
#   4. Installs devpod (release binary, not in any package manager we use)
#   5. Clones tpm so tmux plugins can be installed
#
# It prints the remaining manual steps at the end.
set -euo pipefail

REPO_URL="https://github.com/nishantpillai5/dotfiles-omarchy.git"
DEVPOD_VERSION="v0.6.15"

if ! grep -qi '^ID=arch' /etc/os-release 2>/dev/null; then
  echo "bootstrap: expects Arch/Omarchy, found: $(grep -i '^NAME=' /etc/os-release 2>/dev/null || echo unknown)" >&2
  exit 1
fi

echo "==> 1/5 pacman tools"
sudo pacman -S --needed yadm git lazygit lazydocker git-delta tmux bun

echo "==> 2/5 yadm"
yadm create 2>/dev/null || true
yadm bootstrap "$REPO_URL"
# working checkout for future edits
[ -d ~/dotfiles ] || git clone "$REPO_URL" ~/dotfiles

echo "==> 3/5 mise tools (yazi, fastfetch, direnv, ...)"
if ! command -v mise &>/dev/null; then
  # Omarchy usually ships mise; fall back to the official installer
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
# .config/mise/config.toml now lives in $HOME, which mise auto-trusts
mise install

echo "==> 4/5 devpod"
if ! command -v devpod &>/dev/null; then
  mkdir -p ~/.local/bin
  curl -fsSL -o ~/.local/bin/devpod \
    "https://github.com/loft-sh/devpod/releases/download/${DEVPOD_VERSION}/devpod-linux-amd64"
  chmod +x ~/.local/bin/devpod
fi
devpod version

echo "==> 5/5 tmux plugins (tpm)"
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

cat <<'EOF'

Done. Remaining manual steps:
  1. git identity (kept out of the repo on purpose):
       git config --global user.name "..."
       git config --global user.email "..."
     then add a local config for credentials: ~/.config/git/config_local
  2. open a new shell (picks up ~/.bashrc: aliases, aa, f, fastfetch hook, direnv)
  3. start tmux, press prefix + I to install the tmux plugins
  4. run `direnv allow` in each directory that has a .envrc
EOF
