```bash
## Setup Git Sync on New Machine
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

# Reload shell
source ~/.zshrc

## Usage
config sync "your commit mesage"    # Quick add, commit, & push
config status                       # Normal git commands work too
```
