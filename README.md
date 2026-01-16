# Arch Linux Dotfiles Setup

## Setup New Machine

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

### Clone the Bare Repository

```bash
git clone --bare https://codeberg.org/roee738/dotfiles.git $HOME/.dotfiles
```

### Rename Hyprland Config

```bash
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland1.conf
```

### Restore All Config Files

```bash
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
```
### Set Git Upstream

```bash
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME branch --set-upstream-to=origin/main main
```

### Remove Default Hyprland Config

```bash
rm ~/.config/hypr/hyprland1.conf
```

### Configure Git Credentials

```bash
git config --global credential.helper store
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

### Apply GTK Settings

```bash
nwg-look -a
```

## Usage

```bash
# Quick add, commit, and push
config sync "your commit message"

# Normal git commands work too
config status
```
