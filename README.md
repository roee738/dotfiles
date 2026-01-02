```bash
## Setup Git Sync on New Machine
# Install git
sudo pacman -S git

# Clone the bare repo
git clone --bare https://github.com/roee738/dotfiles.git $HOME/.dotfiles

# Restore all config files
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# Reload shell
source ~/.zshrc

## Usage
config sync "your commit mesage"    # Quick add, commit, & push
config status                       # Normal git commands work too
```
