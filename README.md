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

## Notes

- Ferrix is a tmux alternative - install manually
- Uses NvChad v2.5 for Neovim
- Ghostty theme with VT323 font
- Starship with custom two-line prompt design
