```bash
## Setup Git Sync on New Machine
# Install zsh if not already installed
sudo pacman -S --needed zsh

# Change default shell to zsh
chsh -s $(which zsh)

# Log out and log back in (or reboot) for shell change to take effect
# Then continue with the steps below:

# Clone the bare repo
git clone --bare https://github.com/roee738/dotfiles.git $HOME/.dotfiles

# Restore all config files
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# Install zsh plugins
mkdir -p ~/.config/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.config/zsh/plugins/zsh-history-substring-search

# Reload zsh config
source ~/.zshrc

## Usage
config sync "your commit mesage"    # Quick add, commit, & push
config status                       # Normal git commands work too
```
