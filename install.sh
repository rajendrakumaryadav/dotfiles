#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_PARENT="$(dirname "$DOTFILES_DIR")"
STOW_DIR_NAME="$(basename "$DOTFILES_DIR")"

RED='\033[0;31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
NC='\033[0m'

log() { echo -e "${BLUE}[*]${NC} $1"; }
success() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; }

PACKAGES=(
    "bash:bash:"
    "vim:vim:"
    "nvim:neovim:"
    "ghostty:ghostty:"
    "starship:starship:"
    "zellij:zellij:"
    "sk:skim:"
    "fd:fd-find:"
    "bat:bat:"
    "rg:ripgrep:"
)

detect_package_manager() {
    if command -v apt-get &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v apk &>/dev/null; then
        echo "apk"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v brew &>/dev/null; then
        echo "brew"
    elif command -v zypper &>/dev/null; then
        echo "zypper"
    else
        echo "unknown"
    fi
}

install_package() {
    local pkg="$1"
    local pm
    pm=$(detect_package_manager)

    case "$pm" in
        apt)
            sudo apt-get update
            sudo apt-get install -y "$pkg"
            ;;
        dnf)
            sudo dnf install -y "$pkg"
            ;;
        apk)
            sudo apk add "$pkg"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$pkg"
            ;;
        brew)
            brew install "$pkg"
            ;;
        zypper)
            sudo zypper install -y "$pkg"
            ;;
        *)
            error "Unknown package manager ($pm). Cannot install $pkg."
            return 1
            ;;
    esac
}

is_installed() {
    command -v "$1" &>/dev/null
}

# Node's binary is `node` on most distros but `nodejs` on some (apt). Check both.
is_node_installed() {
    is_installed node || is_installed nodejs
}

# Neovim prerequisites that are NOT dotfiles-packages (no stow dir):
#   distro packages + tree-sitter-cli + uv (python toolchain manager).
NVIM_TOOLS=(
    "node:nodejs:auto"     # npm-based LSP servers (pyright, ts_ls, prettier...)
    "npm:npm:auto"
    "python3:python3:auto" # pip-based mason tools (black, isort, mypy...)
)

ensure_tree_sitter() {
    if is_installed tree-sitter; then
        success "tree-sitter is already installed ($(tree-sitter --version))"
        return 0
    fi

    log "tree-sitter not found (required by nvim-treesitter)."

    # Try the distro package first.
    if install_package tree-sitter-cli; then
        success "tree-sitter installed via package manager"
        return 0
    fi

    # Fallback: build with cargo.
    if command -v cargo &>/dev/null; then
        warn "Installing tree-sitter-cli via cargo (this may take a few minutes)..."
        if cargo install tree-sitter-cli --locked; then
            success "tree-sitter installed via cargo (~/.cargo/bin)"
            return 0
        fi
    fi

    # Last fallback: npm (requires the postinstall script to be allowed).
    if command -v npm &>/dev/null; then
        warn "Installing tree-sitter-cli via npm..."
        if npm install -g --allow-scripts tree-sitter-cli; then
            success "tree-sitter installed via npm"
            return 0
        fi
    fi

    warn "Could not install tree-sitter automatically."
    warn "Install it manually:  https://tree-sitter.github.io/tree-sitter/creating-parsers#installation"
    warn "(e.g. cargo install tree-sitter-cli --locked)"
}

ensure_uv() {
    if is_installed uv; then
        success "uv is already installed ($(uv --version))"
        return 0
    fi

    log "uv not found, installing official installer..."
    if curl -LsSf https://astral.sh/uv/install.sh | sh; then
        export PATH="$HOME/.local/bin:$PATH"
        success "uv installed (uv --version)"
    else
        warn "Failed to install uv. See https://docs.astral.sh/uv/getting-started/installation"
    fi
}

# Python dev tools managed by uv:
#   ruff = fast linter + formatter (replaces black/isort)
#   ty   = fast type checker (replaces mypy/pyright)
# Entry format: binary:uv-package
UV_TOOLS=(
    "ruff:ruff"
    "ty:ty"
)

ensure_uv_tools() {
    if ! is_installed uv; then
        warn "Skipping uv-managed tools (uv not installed)."
        return 0
    fi

    local tool package
    for entry in "${UV_TOOLS[@]}"; do
        tool="${entry%%:*}"
        package="${entry##*:}"
        if is_installed "$tool"; then
            success "$tool is already installed"
        else
            log "Installing $tool via uv..."
            if uv tool install "$package"; then
                success "$tool installed via uv"
            else
                warn "Failed to install $tool. Try: uv tool install $package"
            fi
        fi
    done
}

check_and_install() {
    local tool="$1"
    local package="$2"
    local mode="${3:-auto}"

    if [ "$mode" = "manual" ]; then
        if is_installed "$tool" || { [ "$tool" = "node" ] && is_node_installed; }; then
            success "$tool is already installed"
        else
            warn "$tool not found. Please install it manually."
        fi
        return 0
    fi

    if is_installed "$tool" || { [ "$tool" = "node" ] && is_node_installed; }; then
        success "$tool is already installed"
    else
        warn "$tool not found, attempting to install $package..."
        if install_package "$package"; then
            success "$tool installed successfully"
        else
            warn "Failed to install $tool automatically. Please install it manually."
        fi
    fi
}

stow_package() {
    local pkg="$1"
    local pkg_dir="$DOTFILES_DIR/$pkg"

    if [ ! -d "$pkg_dir" ]; then
        warn "Package directory not found: $pkg"
        return 0
    fi

    if [ -z "$(ls -A "$pkg_dir" 2>/dev/null)" ]; then
        warn "Skipping $pkg (empty directory)"
        return 0
    fi

    log "Stowing $pkg..."
    cd "$STOW_PARENT"

    if stow -v -t "$HOME" -d "$STOW_DIR_NAME" --restow "$pkg"; then
        success "Stowed $pkg"
    else
        error "Failed to stow $pkg. Existing files may conflict."
        warn "Run with --adopt flag or manually backup conflicting files."
    fi
}

echo ""
echo "=== Dotfiles Installer ==="
echo ""

log "Detecting package manager..."
PM=$(detect_package_manager)
log "Using: $PM"
echo ""

log "Checking required tools..."

check_and_install stow stow auto

for entry in "${PACKAGES[@]}"; do
    IFS=':' read -r tool package mode <<< "$entry"
    check_and_install "$tool" "$package" "$mode"
done

echo ""
log "Checking Neovim tooling..."
echo ""

for entry in "${NVIM_TOOLS[@]}"; do
    IFS=':' read -r tool package mode <<< "$entry"
    check_and_install "$tool" "$package" "$mode"
done

ensure_tree_sitter
ensure_uv
ensure_uv_tools

warn "Go is optional for nvim (needed only for gopls/goimports/gofumpt)."
warn "If missing, those Mason packages will simply fail to install - that's fine."
echo ""

echo ""
log "Stowing dotfiles..."
echo ""

for entry in "${PACKAGES[@]}"; do
    IFS=':' read -r tool package mode <<< "$entry"
    stow_package "$tool"
done

echo ""
log "Applying post-install tweaks..."
echo ""

# On Debian / older Ubuntu the `fd-find` package installs the binary as
# `fdfind`. Symlink it to `~/.local/bin/fd` so `pick` (and other tools)
# can find it. $HOME/.local/bin is already on PATH via .bashrc.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    success "linked $(command -v fdfind) -> $HOME/.local/bin/fd"
fi

echo ""
success "=== Done ==="
echo ""
log "Restart your shell or run: source ~/.bashrc"
