#!/usr/bin/env bash
# Bootstrap a new machine with the configs in this repo.
# Safe to re-run: existing configs are backed up, symlinks are refreshed.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
BACKED_UP=0

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok() { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*"; }

backup_and_link() {
  local target="$1" source="$2"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    info "Backing up $target -> $BACKUP_DIR/"
    mv "$target" "$BACKUP_DIR/"
    BACKED_UP=$((BACKED_UP + 1))
  fi
  mkdir -p "$(dirname "$target")"
  ln -sfn "$source" "$target"
  ok "Linked $target -> $source"
}

# --- 1. Packages ---
if command -v brew >/dev/null 2>&1; then
  info "Installing packages from Brewfile"
  brew bundle --file="$REPO_DIR/Brewfile"
  ok "Brew bundle complete"
else
  warn "Homebrew not found — install it first: https://brew.sh"
  warn "Then re-run this script."
  exit 1
fi

# --- 2. Neovim version (LazyVim needs >= 0.11.2) ---
nvim_version="$(nvim --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "0.0.0")"
if [ "$(printf '%s\n' "0.11.2" "$nvim_version" | sort -V | head -1)" != "0.11.2" ]; then
  info "Neovim $nvim_version < 0.11.2, upgrading"
  brew upgrade neovim
fi
ok "Neovim: $(nvim --version | head -1)"

# --- 3. Config symlinks ---
info "Linking configs"

# ai-skills repo (opencode global config references its skills/ directory)
AI_SKILLS_DIR="$HOME/Documents/Projects/ai-skills"
if [ ! -d "$AI_SKILLS_DIR/.git" ]; then
  mkdir -p "$HOME/Documents/Projects"
  info "Cloning ai-skills"
  git clone -q https://github.com/iamwendellbalagot/ai-skills.git "$AI_SKILLS_DIR"
fi
ok "ai-skills: $AI_SKILLS_DIR"

backup_and_link "$HOME/.wezterm.lua" "$REPO_DIR/wezterm/.wezterm.lua"
backup_and_link "$HOME/.tmux.conf" "$REPO_DIR/tmux/.tmux.conf"
backup_and_link "$HOME/.config/nvim" "$REPO_DIR/nvim"
backup_and_link "$HOME/.config/opencode/opencode.jsonc" "$REPO_DIR/opencode/opencode.jsonc"
if [ "$BACKED_UP" -gt 0 ]; then
  warn "Old configs saved in $BACKUP_DIR"
fi

# --- 4. Bootstrap LazyVim plugins ---
info "Syncing LazyVim plugins (first run may take a minute)"
nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || true
ok "LazyVim bootstrapped"

# --- Done ---
echo
ok "Done! Verify:"
echo "   wezterm --version   tmux -V   nvim --version | head -1"
echo "   wezterm start -- nvim     # inside wezterm: :checkhealth"
echo "   tmux new -s test"
echo "   opencode api get /api/skill   # should list karpathy-guidelines (opencode skill)"
echo "   If opencode was running, restart it: opencode service restart"
