#!/bin/bash

set -eu  # Exit on error

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
if ! sudo pacman -S --needed --noconfirm reflector; then
    print_error "Failed to install reflector - skipping mirror update"
else
    if sudo reflector --country US,Canada --age 12 --protocol https --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist; then
        print_success "Mirrors updated"
    else
        print_error "Reflector failed, continuing with existing mirrorlist"
    fi
fi

if sudo pacman -Syu --noconfirm; then
    print_success "System updated"
else
    print_error "System update failed - continuing anyway"
fi

# Edit pacman.conf
print_info "Configuring pacman..."
sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf \
    || print_error "Failed to enable VerbosePkgLists"
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf \
    || print_error "Failed to enable ParallelDownloads"
print_success "Pacman configured"

# Install yay
if ! command -v yay &> /dev/null; then
    print_info "Installing yay..."
    if sudo pacman -S --needed --noconfirm git base-devel go \
        && rm -rf /tmp/yay-build \
        && git clone https://aur.archlinux.org/yay.git /tmp/yay-build \
        && (cd /tmp/yay-build && makepkg -si --noconfirm); then
        print_success "Yay installed"
    else
        print_error "Failed to install yay - AUR packages will be skipped later"
    fi
else
    print_success "Yay already installed"
fi

# Change default shell to zsh
print_info "Checking default shell..."
if ! sudo pacman -S --needed --noconfirm zsh; then
    print_error "Failed to install zsh - skipping shell change"
elif [ "$SHELL" != "$(which zsh)" ]; then
    if chsh -s "$(which zsh)"; then
        print_success "Zsh set as default shell (requires logout/reboot to take effect)"
    else
        print_error "Failed to change shell to zsh"
    fi
else
    print_success "Zsh already set as default shell"
fi

# Setup SSH key for GitHub
print_info "Checking for SSH key..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    print_info "No SSH key found. Setting up SSH key for GitHub..."
    read -p "Enter your email for SSH key: " ssh_email
    while [[ -z "$ssh_email" ]]; do
        echo "Email cannot be empty."
        read -p "Enter your email for SSH key: " ssh_email
    done
    
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
    echo "1. Copy the key above (minus the email)"
    echo "2. Go to https://github.com/settings/keys"
    echo "3. Click 'New SSH key'"
    echo "4. Paste your key and save"
    echo ""
    read -p "Press Enter once you've added the key to GitHub..."
    
    # Test SSH connection
    output=$(ssh -T git@github.com 2>&1 || true)

    if echo "$output" | grep -q "successfully authenticated"; then
        print_success "SSH connection to GitHub successful"
    else
        echo "Warning: Could not verify SSH connection. Continuing anyway..."
    fi
else
    print_success "SSH key already exists"
fi

# Clone dotfiles repo
if [ ! -d "$HOME/.dotfiles" ]; then
    print_info "Cloning dotfiles repository..."
    if ! git clone --bare git@github.com:roee738/dotfiles.git "$HOME/.dotfiles"; then
        print_error "Failed to clone dotfiles repo - cannot continue without it"
        exit 1
    fi
    print_success "Dotfiles cloned"
else
    print_success "Dotfiles already cloned"
fi

# Checkout dotfiles
print_info "Restoring dotfiles..."
if /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout -f; then
    print_success "Dotfiles restored"
else
    print_error "Dotfiles checkout had conflicts - check output above"
fi
/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config --local status.showUntrackedFiles no

# Configure git credentials
if [ -z "$(git config --global user.name 2>/dev/null)" ] || [ -z "$(git config --global user.email 2>/dev/null)" ]; then
    print_info "Configuring git user..."
    read -p "Enter your git username: " git_username
    while [[ -z "$git_username" ]]; do
        echo "Username cannot be empty."
        read -p "Enter your git username: " git_username
    done
    read -p "Enter your git email: " git_email
    while [[ -z "$git_email" ]]; do
        echo "Email cannot be empty."
        read -p "Enter your git email: " git_email
    done
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    print_success "Git configured with username: $git_username and email: $git_email"
else
    print_success "Git already configured as $(git config --global user.name) <$(git config --global user.email)>"
fi

# Download all packages
if [ -f ~/.config/pkglist.txt ]; then
    print_info "Installing packages from pkglist.txt..."
    failed_pkgs=()
    while IFS= read -r pkg || [ -n "$pkg" ]; do
        [ -z "$pkg" ] && continue
        case "$pkg" in \#*) continue ;; esac

        if sudo pacman -S --needed --noconfirm "$pkg"; then
            print_success "Installed $pkg"
        else
            print_error "Failed to install $pkg (skipping)"
            failed_pkgs+=("$pkg")
        fi
    done < ~/.config/pkglist.txt

    if [ ${#failed_pkgs[@]} -eq 0 ]; then
        print_success "Packages installed"
    else
        print_error "Packages failed: ${failed_pkgs[*]}"
    fi
else
    print_error "pkglist.txt not found"
fi

# Install AUR packages
if ! command -v yay &> /dev/null; then
    print_error "yay not found - skipping AUR packages"
elif [ -f ~/.config/aurlist.txt ]; then
    print_info "Installing AUR packages from aurlist.txt..."
    failed_aur_pkgs=()
    while IFS= read -r pkg || [ -n "$pkg" ]; do
        [ -z "$pkg" ] && continue
        case "$pkg" in \#*) continue ;; esac

        if yay -S --needed --noconfirm "$pkg"; then
            print_success "Installed $pkg"
        else
            print_error "Failed to install $pkg (skipping)"
            failed_aur_pkgs+=("$pkg")
        fi
    done < ~/.config/aurlist.txt

    if [ ${#failed_aur_pkgs[@]} -eq 0 ]; then
        print_success "AUR packages installed"
    else
        print_error "AUR packages failed: ${failed_aur_pkgs[*]}"
    fi
else
    print_error "aurlist.txt not found"
fi

# Install zsh plugins
print_info "Installing zsh plugins..."
mkdir -p ~/.config/zsh/plugins

if [ ! -d ~/.config/zsh/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions \
        || print_error "Failed to clone zsh-autosuggestions"
fi
if [ ! -d ~/.config/zsh/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting \
        || print_error "Failed to clone zsh-syntax-highlighting"
fi
if [ ! -d ~/.config/zsh/plugins/zsh-history-substring-search ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.config/zsh/plugins/zsh-history-substring-search \
        || print_error "Failed to clone zsh-history-substring-search"
fi
print_success "Zsh plugins step complete"

# Disable SDDM
if systemctl is-enabled sddm.service &> /dev/null; then
    print_info "Disabling SDDM..."
    sudo systemctl disable sddm.service || print_error "Failed to disable SDDM"
    print_success "SDDM disabled"
else
    print_info "SDDM is not enabled, skipping..."
fi

# Add Windows entry to bootloader
print_info "Detecting EFI partitions..."
lsblk -o NAME,SIZE,FSTYPE,LABEL | grep -i fat || true
print_info "Enter Windows EFI partition (e.g. nvme0n1p1):"
read -r efi_partition
while [[ -z "$efi_partition" ]]; do
    echo "Partition cannot be empty."
    read -r efi_partition
done
if ! sudo mkdir -p /mnt/windows-efi; then
    print_error "Failed to create /mnt/windows-efi - skipping Windows bootloader entry"
elif sudo mount "/dev/$efi_partition" /mnt/windows-efi; then
    print_success "Windows EFI partition mounted"
    print_info "Copying Windows EFI files..."
    if [ -d /mnt/windows-efi/EFI/Microsoft ]; then
        if sudo cp -r /mnt/windows-efi/EFI/Microsoft /boot/EFI/; then
            print_success "Windows EFI files copied"
        else
            print_error "Failed to copy Windows EFI files"
        fi
    else
        print_error "Microsoft EFI folder not found on /dev/$efi_partition"
    fi
    sudo umount /mnt/windows-efi || print_error "Failed to unmount /mnt/windows-efi"
    print_success "Windows EFI step complete"
else
    print_error "Failed to mount /dev/$efi_partition"
fi

# Laptop detection
print_info "Detecting system type..."
if ls /sys/class/power_supply/ | grep -q "^BAT"; then
    echo "Laptop detected, applying power management settings..."
    
    # Install laptop specific packages
    print_info "Installing laptop specific packages..."
    if sudo pacman -S --needed --noconfirm acpi brightnessctl; then
        print_success "Packages installed"
    else
        print_error "Failed to install laptop packages - continuing"
    fi
    
    # Start auto-cpufreq
    print_info "Checking auto-cpufreq..."
    if ! systemctl is-active --quiet auto-cpufreq 2>/dev/null; then
        if sudo auto-cpufreq --install; then
            print_success "Auto-cpufreq installed and started"
        else
            print_error "auto-cpufreq install failed"
        fi
    else
        print_success "auto-cpufreq already running"
    fi

    # Configure logind
    print_info "Configuring logind..."
    sudo sed -i 's/^#HandleSuspendKey=suspend/HandleSuspendKey=ignore/' /etc/systemd/logind.conf \
        || print_error "Failed to set HandleSuspendKey"
    sudo sed -i 's/^#HandlePowerKey=poweroff/HandlePowerKey=ignore/' /etc/systemd/logind.conf \
        || print_error "Failed to set HandlePowerKey"
    print_success "logind configured"
fi

echo ""
echo "========================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "========================================="
echo ""
echo "Please log out and log back in (or reboot) for all changes to take effect."
echo ""
