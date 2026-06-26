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
├── ferrix/
│   └── .config/ferrix/config
├── install.sh
└── README.md
```

## Tools

- **nvim** - Neovim with NvChad config
- **vim** - Vim (minimal config)
- **ghostty** - Terminal emulator
- **starship** - Cross-shell prompt
- **ferrix** - Tmux alternative (manual install)
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
stow -n -v -t ~ bash vim nvim ghostty starship ferrix

# Stow all
stow -v -t ~ bash vim nvim ghostty starship ferrix

# Stow individual package
stow -v -t ~ nvim
```

## Requirements

- stow
- Neovim (optional)
- Vim (optional)
- Ghostty (optional)
- Starship (optional)
- Ferrix (manual install required)

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

## Notes

- Ferrix is a tmux alternative - install manually
- Uses NvChad v2.5 for Neovim
- Ghostty theme with VT323 font
- Starship with custom two-line prompt design
