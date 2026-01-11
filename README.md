```bash
## Setup New Machine
# Update mirrors
sudo pacman -S --needed reflector
sudo reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syu

# Edit pacman.conf
sudo nvim /etc/pacman.conf

# Uncomment multilib
[multilib]
Include = /etc/pacman.d/mirrorlist

# Uncomment in Misc options section
Color
VerbosePkgLists
ParallelDownloads = 10

# Install yay
sudo pacman -S --needed git base-devel go && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Change default shell to zsh
sudo pacman -S --needed zsh
chsh -s $(which zsh)

# Log out and log back in (or reboot) for shell change to take effect
# Then continue with the steps below:

## Setup Git Sync
# Clone the bare repo
git clone --bare https://github.com/roee738/dotfiles.git $HOME/.dotfiles

# Rename hyprland conf
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland1.conf

# Restore all config files
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# Remove default hyprland conf
rm ~/.config/hypr/hyprland1.conf

# Configure git credentials
git config --global credential.helper store
git config --global user.name "roee"
git config --global user.email "roee738@gmail.com"

# Download all packages
sudo pacman -S --needed - < ~/.config/pkglist.txt

# Install zsh plugins
mkdir -p ~/.config/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.config/zsh/plugins/zsh-history-substring-search

# Reload zsh config
source ~/.zshrc

# Install AUR packages
yay -S --needed - < ~/.config/aurlist.txt

# Start auto-cpufreq
sudo auto-cpufreq --install

# Make a commit in order to set credentials locally
config sync "update"

## Usage
config sync "your commit mesage"    # Quick add, commit, & push
config status                       # Normal git commands work too
```
