# Dotfiles

My dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── bash/
│   ├── .bashrc
│   └── .bash_profile
├── vim/
│   └── .vimrc
├── nvim/
│   └── .config/nvim/
│       ├── init.lua
│       ├── .stylua.toml
│       └── lua/
│           ├── options.lua
│           ├── mappings.lua
│           ├── autocmds.lua
│           ├── chadrc.lua
│           ├── configs/
│           └── plugins/
├── ghostty/
│   └── .config/ghostty/config
├── starship/
│   └── .config/starship.toml
├── zellij/
│   └── .config/zellij/config.kdl
├── bin/
│   └── pick              # sk-powered fuzzy finder / file picker
├── install.sh
└── README.md
```

## Tools

- **nvim** - Neovim with NvChad config
- **vim** - Vim (minimal config)
- **ghostty** - Terminal emulator
- **starship** - Cross-shell prompt
- **zellij** - Terminal multiplexer
- **pick** - sk-powered fuzzy finder / mac-style file picker
- **bash** - Shell config (.bashrc, .bash_profile)

## Installation

```bash
cd ~/Documents/projects/dotfiles
./install.sh
```

The install script will:
1. Detect your package manager (apt, dnf, apk, pacman, brew, zypper)
2. Install any missing tools automatically
3. Stow all dotfiles to your home directory

## Manual Setup

If you already have dotfiles in ~, you may need to remove or backup them first:

```bash
# Backup existing configs
mkdir -p ~/dotfiles-backup
mv ~/.bashrc ~/dotfiles-backup/ 2>/dev/null || true
# ... repeat for other files

# Then run install
./install.sh
```

## Manual Stow

```bash
# Preview what will be stowed
stow -n -v -t ~ bash vim nvim ghostty starship zellij bin

# Stow all
stow -v -t ~ bash vim nvim ghostty starship zellij bin

# Stow individual package
stow -v -t ~ nvim
```

## Requirements

- stow
- Neovim (optional)
- Vim (optional)
- Ghostty (optional)
- Starship (optional)
- Zellij (auto-installed; or grab the binary from https://zellij.dev)
- skim (`sk`) (auto-installed) — required for `pick`
- fd, bat, ripgrep (auto-installed; fall back to `find`/`head`/`grep` if missing)

## Neovim (nvim)

NvChad v2.5 based configuration. Leader key is **`<Space>`** and local leader is also **`<Space>`**.

Plugins installed via `lazy.nvim`:
- **NvChad** - base UI (statusline, base46 themes, terminal, etc.)
- **nvim-lspconfig** - LSP support for `lua_ls`, `pyright`, `ts_ls`, `html`, `cssls`, `gopls`, `rust_analyzer`, `zls`
- **conform.nvim** - formatter (stylua for Lua, rustfmt for Rust, zig fmt for Zig)
- **nvim-treesitter** - syntax highlighting for vim/lua/vimdoc/html/css/rust/zig

Config files:
- `lua/mappings.lua` - custom keymaps
- `lua/options.lua` - editor options
- `lua/autocmds.lua` - autocommands
- `lua/chadrc.lua` - NvChad UI tweaks
- `lua/configs/lazy.lua` - lazy.nvim setup
- `lua/configs/lspconfig.lua` - LSP servers
- `lua/configs/conform.lua` - formatters
- `lua/plugins/init.lua` - plugin specs

### Custom Keymaps

Defined in `nvim/.config/nvim/lua/mappings.lua`. Many more (LSP, Telescope, NvimTree, terminal, etc.) are inherited from NvChad defaults.

#### Basics

| Key | Mode | Action |
| --- | --- | --- |
| `;` | Normal | Enter command mode (replaces `:`) |
| `jk` / `kj` | Insert | Escape to Normal mode |

#### Save / Quit

| Key | Action |
| --- | --- |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Save and quit |
| `<leader>/` | Clear search highlights |

#### Window Navigation

| Key | Action |
| --- | --- |
| `<C-h>` | Move to left window |
| `<C-j>` | Move to lower window |
| `<C-k>` | Move to upper window |
| `<C-l>` | Move to right window |

#### Split Management

| Key | Action |
| --- | --- |
| `<leader>sv` | Split window vertically |
| `<leader>sh` | Split window horizontally |
| `<leader>se` | Make all splits equal size |
| `<leader>sx` | Close current split |

#### File Explorer (NvimTree)

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle file explorer |
| `<C-n>` | Toggle file explorer |

#### Buffer Management

| Key | Action |
| --- | --- |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Close buffer |
| `<leader>bD` | Force close buffer |

#### Clipboard / Text Manipulation

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>y` | Normal, Visual | Yank selection to system clipboard |
| `<leader>Y` | Normal | Yank entire line to system clipboard |
| `<leader>d` | Normal | Duplicate current line |
| `J` | Visual | Move selected lines down |
| `K` | Visual | Move selected lines up |

#### LSP / Formatting

| Key | Action |
| --- | --- |
| `<leader>lf` | Format buffer (conform.nvim) |

Search navigation (`n` / `N`) keeps the cursor vertically centered.

#### Terminal

| Key | Mode | Action |
| --- | --- | --- |
| `<Esc>` | Terminal | Return to Normal mode |

### Inherited NvChad Keymaps (default)

For convenience, the most useful built-ins are:

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fw` | Live grep (Telescope) |
| `<leader>fb` | List buffers (Telescope) |
| `<leader>fh` | Search help tags |
| `<leader>tt` | Toggle terminal |
| `<leader>th` | Toggle horizontal terminal |
| `<leader>ca` | Code action (LSP) |
| `<leader>rn` | Rename symbol (LSP) |
| `gd` | Go to definition (LSP) |
| `gr` | Go to references (LSP) |
| `K` | Hover documentation (LSP) |
| `gcc` | Toggle line comment |

### Language Support

| Language | LSP Server | Formatter | Tree-sitter |
| --- | --- | --- | --- |
| Lua | `lua_ls` | `stylua` | yes |
| Python | `pyright` | - | - |
| TypeScript / JS | `ts_ls` | - | - |
| HTML | `html` | - | yes |
| CSS | `cssls` | - | yes |
| Go | `gopls` | - | - |
| Rust | `rust_analyzer` (clippy on save) | `rustfmt` | yes |
| Zig | `zls` | `zig fmt` | yes |

#### Tool Requirements

The LSP servers and formatters must be installed separately on your system
(the editor will not install them):

- **Lua**: `stylua`
- **Python**: `pyright`
- **TypeScript / JS**: `typescript-language-server` (`npm i -g typescript-language-server`)
- **HTML / CSS**: `vscode-langservers-extracted` (`npm i -g vscode-langservers-extracted`)
- **Go**: `gopls` (`go install golang.org/x/tools/gopls@latest`)
- **Rust**: `rust-analyzer` (via `rustup component add rust-analyzer`), `rustfmt`, `clippy`
- **Zig**: `zls` (https://github.com/zigtools/zls), `zig` (ships `zig fmt`)

Run `:Telescope keymaps` inside Neovim to browse every active keymap.

## Zellij (terminal multiplexer)

Config lives in `zellij/.config/zellij/config.kdl`. All default keybindings are
preserved, so the on-screen **Shortcuts panel** (`Ctrl-o` then click "Shortcuts",
or press `?`) lists every binding. Highlights:

| Key | Mode | Action |
| --- | --- | --- |
| `Ctrl-o` | any | Enter Session mode (status bar appears) |
| `Ctrl-p` | any | Enter Pane mode |
| `Ctrl-t` | any | Enter Tab mode |
| `Ctrl-s` | any | Enter Scroll mode |
| `Ctrl-n` | any | Enter Resize mode |
| `Ctrl-h` | any | Enter Move mode (re-arrange panes) |
| `Ctrl-g` | any | Lock session |
| `Ctrl-q` | any | Quit zellij |
| `Enter` / `Space` / `Esc` | inside any mode | Back to Normal |
| `Alt + ←/→/↑/↓` | normal | Move focus across panes / tabs |
| `Alt + n` | normal | New pane |
| `Alt + =` / `Alt + -` | normal | Resize focused pane |
| `Alt + p` | normal | Toggle pane-in-group |
| `Alt + Shift + p` | normal | Toggle group marking |

In-app panels (open with `Ctrl-o`):

- **Status**   — overview of running sessions
- **Tab**      — create / rename / close tabs
- **Pane**     — split, close, fullscreen, float panes
- **Plugin**   — manage UI plugins (tab-bar, status-bar, strider, compact-bar)
- **Session**  — detach, quit, lock
- **Shortcuts** — full keymap reference (this is your discoverability friend)
- **About**    — version / diagnostic info

Mouse mode is on by default: click to focus, drag pane borders to resize,
scroll wheel to scroll the active pane, double-click to select a word, and
shift-drag to extend the selection. Selection is auto-copied to the system
clipboard (`copy_on_select true`).

Scrollback editor is `nvim` — press `Ctrl-o e` from scroll mode to open the
buffer in your editor and write the changes back.

`mirror_session true` lets you SSH/remote into a machine and see the same
zellij session; the same UI is also shown on the host.

Themes are KDL files shipped with zellij. Some popular ones:
`default`, `dracula`, `catppuccin-mocha`, `catppuccin-latte`, `tokyo-night`,
`tokyo-night-storm`, `nord`, `gruvbox-dark`, `gruvbox-light`, `onedark`,
`flexoki-dark`, `everforest-dark`, `ayu-dark`, `ayu-light`, `solarized-dark`,
`night-owl`. Change the active theme with `theme "tokyo-night"` in
`config.kdl`.

### Auto-start on terminal open

`.bashrc` ends with a guard that `exec`s zellij the first time an interactive
shell opens. After install, **open a new terminal** and you'll land inside a
zellij session immediately.

The auto-start is skipped when any of these are true:

- `ZELLIJ_AUTO=0` is exported (opt-out — set in `~/.bash_profile` to disable permanently)
- `ZELLIJ` is already in the environment (we are inside a zellij pane)
- `TMUX` is in the environment (we are inside tmux)
- The shell is not interactive (no `PS1`)
- There is no TTY on stdin / stdout (piped / scripted shells)
- `zellij` is not on `PATH`

To temporarily bypass auto-start for a single shell (e.g. to get a bare bash
inside an existing zellij pane), launch bash with `bash --norc` or set
`ZELLIJ_AUTO=0` for that command.

### Shell aliases

Defined in `bash/.bashrc` (only when `zellij` is on `PATH`):

| Alias | Command | Notes |
| --- | --- | --- |
| `z` | `zellij` | top-level |
| `zj` | `zellij` | alt |
| `za [name]` | `zellij attach` | attach to `name` or start a new one |
| `zls` | `zellij list-sessions` | list running sessions |
| `zk [name]` | `zellij kill-session` | kill the current / named session |
| `zka` | `zellij kill-all-sessions` | panic button |
| `zm [name]` | `zellij delete-session` | delete a session from the list |

### Workflow tips

- `Ctrl-o` opens the session manager. From there click **Status** to see
  every running session and jump between them.
- `Ctrl-q` detaches (zellij keeps running in the background). Re-attach
  from any terminal with `za`.
- `Ctrl-g` locks the session (a passphrase prompt re-opens it).
- For SSH/remote workflows, run `zellij` on the remote too — with
  `mirror_session true` the same UI is shown on the host and remote.

## pick (skim-powered fuzzy finder / file picker)

`bin/pick` is a single-file Bash wrapper around [`sk`](https://github.com/lotabout/skim)
that gives you a **Telescope-like fuzzy finder** at the shell level plus a
**macOS-style file picker** for quick access to every file and folder.

### Subcommands

| Command | Alias | Behavior |
| --- | --- | --- |
| `pick` | `p` | mac-style file picker — opens the selected file with `xdg-open` (Linux) or `open` (macOS). Use **Tab** to cd into a folder. |
| `pick file` | `pf` | fuzzy-find files across the cwd; opens in `$EDITOR` |
| `pick grep` | `pg` | type a pattern, then a file:line jump, opens in `$EDITOR` at the match |
| `pick dir` | `pd` | fuzzy-find directories; `cd`s into the result |
| `pick recent` | `pr` | recently modified files; opens in `$EDITOR` |
| `pick git` | `pgs` | modified / untracked files in the current git repo |
| `pick help` | | full help and key map |

### In-app keys (skim)

| Key | Action |
| --- | --- |
| `Enter` | accept the selection (default action of the subcommand) |
| `Tab` / `Alt-B` | cd into the selected directory (picker only) |
| `Alt-Enter` | open the selected file in `$EDITOR` (picker only) |
| `Alt-O` | open with the OS default app |
| `Ctrl-Y` | copy the path to the clipboard |
| `Ctrl-/` | toggle the preview pane |
| `Esc` / `Ctrl-C` / `Ctrl-Q` | abort |

### Dependencies

| Tool | Required | Used for | Fallback |
| --- | --- | --- | --- |
| `sk` | yes | the fuzzy finder | — |
| `fd` | optional | fast file / dir discovery | `find` |
| `bat` | optional | file preview (with line numbers + colors) | `head` |
| `rg` | optional | `pick grep` | `grep -RIn` |
| `xdg-open` / `open` | optional | default-app opener | `$EDITOR` |
| `wl-copy` / `xclip` / `xsel` / `pbcopy` | optional | clipboard (Ctrl-Y) | — |

On Debian / older Ubuntu the `fd-find` package installs the binary as
`fdfind`; the installer auto-creates `~/.local/bin/fd` → `fdfind` so
`pick` finds it.

### Examples

```bash
# Open the mac-style file picker
p

# Fuzzy-find any file in cwd and edit it
pf

# Grep "TODO" across the repo, jump to the match
pg   # then type "TODO"

# Cd into a directory
pd

# Edit the most recently changed files
pr

# Open a file from git status
pgs
```

## Notes

- Uses NvChad v2.5 for Neovim
- Ghostty theme with VT323 font
- Starship with custom two-line prompt design
- Zellij for terminal multiplexing (defaults kept so the in-app Shortcuts panel shows every keybind)
- `pick` for shell-level fuzzy finding (skim backend)
