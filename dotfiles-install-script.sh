#!/bin/bash

set -e  # Exit on error

echo "========================================="
echo "Arch Linux Dotfiles Setup"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

# Check if running on Arch Linux
if [ ! -f /etc/os-release ] || ! grep -q "^ID=arch$" /etc/os-release; then
    print_error "This script is designed for Arch Linux!"
    exit 1
fi

# Update mirrors
print_info "Updating package mirrors..."
sudo pacman -S --needed --noconfirm reflector
sudo reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syu --noconfirm
print_success "Mirrors updated"

# Edit pacman.conf
print_info "Configuring pacman..."
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf

# Enable multilib
sudo sed -i 's/^#\[multilib\]/[multilib]/' /etc/pacman.conf
sudo sed -i '/\[multilib\]/,/^$/ s/^#Include/Include/' /etc/pacman.conf

sudo pacman -Sy
print_success "Pacman configured"

# Install yay
if ! command -v yay &> /dev/null; then
    print_info "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel go
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
    print_success "Yay installed"
else
    print_success "Yay already installed"
fi

# Change default shell to zsh
print_info "Installing zsh and setting as default shell..."
sudo pacman -S --needed --noconfirm zsh
chsh -s $(which zsh)
print_success "Zsh set as default shell (requires logout/reboot to take effect)"

# Setup SSH key for GitHub
print_info "Checking for SSH key..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    print_info "No SSH key found. Setting up SSH key for GitHub..."
    read -p "Enter your email for SSH key: " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519" -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    
    echo ""
    echo "========================================="
    echo "SSH KEY SETUP REQUIRED"
    echo "========================================="
    echo "Your public SSH key:"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Please:"
    echo "1. Copy the key above"
    echo "2. Go to https://github.com/settings/keys"
    echo "3. Click 'New SSH key'"
    echo "4. Paste your key and save"
    echo ""
    read -p "Press Enter once you've added the key to GitHub..."
    
    # Test SSH connection
    print_info "Testing GitHub SSH connection..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_success "SSH connection to GitHub successful"
    else
        print_error "SSH connection failed. Please check your SSH key setup."
        exit 1
    fi
else
    print_success "SSH key already exists"
fi

# Clone dotfiles repo
if [ ! -d "$HOME/.dotfiles" ]; then
    print_info "Cloning dotfiles repository..."
    git clone --bare git@github.com:roee738/dotfiles.git $HOME/.dotfiles
    print_success "Dotfiles cloned"
else
    print_success "Dotfiles already cloned"
fi

# Checkout dotfiles
print_info "Restoring dotfiles..."
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
print_success "Dotfiles restored"

# Configure git credentials
print_info "Configuring git user..."
read -p "Enter your git username [roee]: " git_username
git_username=${git_username:-roee}
read -p "Enter your git email [roee738@gmail.com]: " git_email
git_email=${git_email:-roee738@gmail.com}
git config --global user.name "$git_username"
git config --global user.email "$git_email"
print_success "Git configured"

# Download all packages
if [ -f ~/.config/pkglist.txt ]; then
    print_info "Installing packages from pkglist.txt..."
    sudo pacman -S --needed --noconfirm - < ~/.config/pkglist.txt
    print_success "Packages installed"
else
    print_error "pkglist.txt not found"
fi

# Install AUR packages
if [ -f ~/.config/aurlist.txt ]; then
    print_info "Installing AUR packages from aurlist.txt..."
    yay -S --needed --noconfirm - < ~/.config/aurlist.txt
    print_success "AUR packages installed"
else
    print_error "aurlist.txt not found"
fi

# Install zsh plugins
print_info "Installing zsh plugins..."
mkdir -p ~/.config/zsh/plugins
[ ! -d ~/.config/zsh/plugins/zsh-autosuggestions ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
[ ! -d ~/.config/zsh/plugins/zsh-syntax-highlighting ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting
[ ! -d ~/.config/zsh/plugins/zsh-history-substring-search ] && \
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.config/zsh/plugins/zsh-history-substring-search
print_success "Zsh plugins installed"

# Start auto-cpufreq
if command -v auto-cpufreq &> /dev/null; then
    print_info "Installing auto-cpufreq service..."
    sudo auto-cpufreq --install
    print_success "Auto-cpufreq installed"
fi

# Configure logind
print_info "Configuring logind..."
sudo sed -i 's/^#HandleSuspendKey=suspend/HandleSuspendKey=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/^#HandlePowerKey=poweroff/HandlePowerKey=ignore/' /etc/systemd/logind.conf
print_success "Logind configured"

echo ""
echo "========================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "========================================="
echo ""
echo "Please log out and log back in (or reboot) for all changes to take effect."
echo ""
