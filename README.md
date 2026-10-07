# dotfiles

Terminal + editor setup: **WezTerm**, **tmux**, **LazyVim** — all using
**JetBrains Mono Nerd Font**.

## Layout

```
.
├── Brewfile              # packages + font
├── install.sh            # bootstrap script (idempotent)
├── wezterm/.wezterm.lua  # -> ~/.wezterm.lua
├── tmux/.tmux.conf       # -> ~/.tmux.conf
├── nvim/                 # -> ~/.config/nvim  (LazyVim starter)
└── opencode/opencode.jsonc # -> ~/.config/opencode/opencode.jsonc
```

## New machine setup

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  # if no brew
git clone https://github.com/iamwendellbalagot/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script:

1. Installs everything in the `Brewfile` (wezterm, tmux, neovim, font)
2. Upgrades neovim if older than 0.11.2 (required by LazyVim)
3. Clones the [ai-skills](https://github.com/iamwendellbalagot/ai-skills) repo to `~/Documents/Projects/ai-skills`
4. Backs up any existing `~/.wezterm.lua`, `~/.tmux.conf`, `~/.config/nvim`,
   `~/.config/opencode/opencode.jsonc`
   (to `~/.dotfiles-backup-<timestamp>/`), then symlinks the repo configs
5. Bootstraps LazyVim plugins (`Lazy! sync`)

The `opencode.jsonc` global config registers `~/Documents/Projects/ai-skills/skills`
with opencode, so skills from that repo (e.g. `karpathy-guidelines`) are
discovered and advertised in every project.

## Day-to-day

- Edit configs directly in this repo — they're symlinked into place.
- Reload tmux: `prefix` + `r`
- WezTerm reloads its config automatically on save.
- Plugin state lives in `~/.local/share/nvim`, not in this repo.

## Useful keys

| Where  | Keys                                          |
| ------ | --------------------------------------------- |
| tmux   | prefix `Ctrl-b`, splits `\|` and `-`          |
| tmux   | `Alt-1..9` switch windows, vi copy mode (`v`/`y`) |
| WezTerm| `Cmd-\|` / `Cmd--` splits, `Cmd-Alt-arrows` pane nav |
