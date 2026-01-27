# Arch Linux Dotfiles Setup

## Quick Install (Recommended)
For automated setup on a fresh Arch system:
```bash
# Download and run the install script
sudo pacman -S --needed curl
curl -o install.sh https://raw.githubusercontent.com/roee738/dotfiles/main/dotfiles-install-script.sh
chmod +x install.sh
./install.sh
```
The script will guide you through SSH key setup for GitHub access.

After installation completes, log out and log back in (or reboot) for all changes to take effect.

## Manual Setup
If you prefer to set up manually, follow these steps:

### Update Mirrors
```bash
sudo pacman -S --needed reflector
sudo reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syu
```

### Edit pacman.conf
```bash
sudo nvim /etc/pacman.conf
```
Uncomment the following in the multilib section:
```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```
Uncomment in Misc options section:
```ini
Color
VerbosePkgLists
ParallelDownloads = 10
```

### Install yay
```bash
sudo pacman -S --needed git base-devel go
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Change Default Shell to zsh
```bash
sudo pacman -S --needed zsh
chsh -s $(which zsh)
```
**Note:** Log out and log back in (or reboot) for shell change to take effect, then continue with the steps below.

## Setup Git Sync

### Setup SSH Key for GitHub
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Display your public key
cat ~/.ssh/id_ed25519.pub
```

Copy the output and add it to GitHub:
1. Go to https://github.com/settings/keys
2. Click "New SSH key"
3. Paste your public key
4. Click "Add SSH key"

Test the connection:
```bash
ssh -T git@github.com
```

### Clone the Bare Repository
```bash
git clone --bare git@github.com:roee738/dotfiles.git $HOME/.dotfiles
```

### Restore All Config Files
```bash
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
```

### Configure Git User
```bash
git config --global user.name "roee"
git config --global user.email "roee738@gmail.com"
```

### Download All Packages
```bash
sudo pacman -S --needed - < ~/.config/pkglist.txt
```

### Install Zsh Plugins
```bash
mkdir -p ~/.config/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.config/zsh/plugins/zsh-history-substring-search
```

### Reload Zsh Config
```bash
source ~/.zshrc
```

### Install AUR Packages
```bash
yay -S --needed - < ~/.config/aurlist.txt
```

### Start auto-cpufreq
```bash
sudo auto-cpufreq --install
```

### Disable sleep key
```bash
sudo nvim /etc/systemd/logind.conf
# Uncomment and amend these lines:
HandleSuspendKey=ignore
HandlePowerKey=ignore
# Reboot system
```

## Usage
```bash
# Quick add, commit, and push
config sync "your commit message"

# Normal git commands work too
config status
```
