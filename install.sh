#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

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
    local pm=$(detect_package_manager)

    case "$pm" in
        apt)
            sudo apt-get update && sudo apt-get install -y "$pkg"
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
            echo "Cannot install $pkg: unknown package manager ($pm)"
            return 1
            ;;
    esac
}

is_installed() {
    command -v "$1" &>/dev/null
}

check_and_install() {
    local tool="$1"
    local package="${2:-$tool}"

    if is_installed "$tool"; then
        echo "[SKIP] $tool is already installed"
    else
        echo "[INSTALL] $tool not found, installing..."
        install_package "$package"
    fi
}

echo "=== Dotfiles Installer ==="
echo ""

echo "Detecting package manager..."
PM=$(detect_package_manager)
echo "Using: $PM"
echo ""

echo "=== Checking required tools ==="

check_and_install stow stow
check_and_install nvim neovim
check_and_install vim vim
check_and_install ghostty ghostty
check_and_install starship starship
check_and_install ferrix

echo ""
echo "=== Stowing dotfiles ==="

STOW_PARENT="$(dirname "$DOTFILES_DIR")"
cd "$STOW_PARENT"

for pkg in bash vim nvim ghostty starship ferrix; do
    if [ -d "$DOTFILES_DIR/$pkg" ] && [ "$(ls -A "$DOTFILES_DIR/$pkg" 2>/dev/null)" ]; then
        echo "[STOW] $pkg"
        stow -v -t "$HOME" -d dotfiles "$pkg"
    else
        echo "[SKIP] $pkg (no files)"
    fi
done

echo ""
echo "=== Done ==="
echo ""
echo "Restart your shell or run: source ~/.bashrc"
