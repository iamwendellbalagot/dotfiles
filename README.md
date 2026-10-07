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

1. Installs everything in the `Brewfile` (wezterm, tmux, neovim, font, language servers)
2. Installs `mcp-language-server` (`go install`) — the LSP↔MCP bridge for opencode
3. Installs `typescript-language-server` + classic `typescript@5` into a dedicated
   npm prefix at `~/.ts-ls-server` (see notes below)
4. Upgrades neovim if older than 0.11.2 (required by LazyVim)
5. Clones the [ai-skills](https://github.com/iamwendellbalagot/ai-skills) repo to `~/Documents/Projects/ai-skills`
6. Backs up any existing `~/.wezterm.lua`, `~/.tmux.conf`, `~/.config/nvim`,
   `~/.config/opencode/opencode.jsonc`
   (to `~/.dotfiles-backup-<timestamp>/`), then symlinks the repo configs
7. Bootstraps LazyVim plugins (`Lazy! sync`)

The `opencode.jsonc` global config:

- Registers `~/Documents/Projects/ai-skills/skills`, so skills from that repo
  (e.g. `karpathy-guidelines`) are discovered and advertised in every project.
- Registers five language MCP servers (`typescript`, `python`, `rust`, `swift`,
  `kotlin`), each fronting that language's LSP server through
  `mcp-language-server`. The agent gets `definition`, `references`,
  `diagnostics`, `hover`, `rename_symbol`, and `edit_file` tools per language.
  LSP backends: `typescript-language-server`, `pyright-langserver`,
  `rust-analyzer`, `sourcekit-lsp` (ships with Xcode CLT), `kotlin-language-server`.
- The `kotlin` server gets a 120 s startup timeout — the JVM cold start regularly
  exceeds opencode's default 30 s.

## Language tooling

The MCP servers rely on these LSP backends:

| opencode server | Language | LSP backend | Installed via |
| --- | --- | --- | --- |
| `typescript` | TypeScript / JavaScript | `typescript-language-server` | npm prefix `~/.ts-ls-server` |
| `python` | Python | `pyright-langserver` | Homebrew (Brewfile) |
| `rust` | Rust | `rust-analyzer` | Homebrew (Brewfile) |
| `swift` | Swift | `sourcekit-lsp` | Xcode CLT |
| `kotlin` | Kotlin | `kotlin-language-server` | Homebrew (Brewfile) |

**Why `~/.ts-ls-server` instead of Homebrew for TypeScript?** Homebrew's
`typescript-language-server` formula depends on the Homebrew `typescript`
formula, which is now the native Go compiler (typescript@7). TypeScript 7
dropped `tsserver.js`, so `typescript-language-server` has no server to spawn
and exits with "Could not find a valid TypeScript installation". install.sh
therefore installs `typescript-language-server` + classic `typescript@5`
(`lib/tsserver.js`) into a dedicated npm prefix, and `opencode.jsonc` points
the `typescript` MCP server at `~/.ts-ls-server/bin/typescript-language-server`.
If a future Homebrew release bundles a compatible classic or native-capable
server again, delete the npm prefix and point the config back at the brew binary.

Check connections after install with `opencode mcp list`; restart opencode
(`opencode service restart`) if it was already running when you installed.

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
