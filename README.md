# Dotfiles

My dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── bash/          -> ~/.bashrc
├── vim/           -> ~/.vimrc
├── nvim/          -> ~/.config/nvim/
├── ghostty/       -> ~/.config/ghostty/
├── starship/      -> ~/.config/starship/
└── ferrix/        -> ~/.config/ferrix/
```

## Tools

- **nvim** - Neovim with NvChad config
- **vim** - Vim (minimal config)
- **ghostty** - Terminal emulator
- **starship** - Cross-shell prompt
- **ferrix** - Tmux alternative
- **bash** - Shell config

## Installation

```bash
./install.sh
```

The install script will:
1. Detect your package manager (apt, dnf, apk, pacman, brew, zypper)
2. Install any missing tools automatically
3. Stow all dotfiles to your home directory

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
- Ferrix (optional)

## Notes

- Ferrix is a tmux alternative
- Uses NvChad v2.5 for Neovim
- Ghostty theme with VT323 font
