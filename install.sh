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
    "ferrix:ferrix:manual"
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

check_and_install() {
    local tool="$1"
    local package="$2"
    local mode="${3:-auto}"

    if [ "$mode" = "manual" ]; then
        if is_installed "$tool"; then
            success "$tool is already installed"
        else
            warn "$tool not found. Please install it manually."
        fi
        return 0
    fi

    if is_installed "$tool"; then
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
log "Stowing dotfiles..."
echo ""

for entry in "${PACKAGES[@]}"; do
    IFS=':' read -r tool package mode <<< "$entry"
    stow_package "$tool"
done

echo ""
success "=== Done ==="
echo ""
log "Restart your shell or run: source ~/.bashrc"
