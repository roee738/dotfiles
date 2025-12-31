## Setup Git Sync on New Machine
```bash
# Install git
sudo pacman -S git

# Clone the bare repository
git clone --bare https://github.com/roee738/dotfiles.git $HOME/.dotfiles

# Setup the config alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Restore all config files
config checkout

# Configure the repo
config config --local status.showUntrackedFiles no

# Add alias permanently to zshrc
echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ~/.zshrc
source ~/.zshrc
```

## Daily Usage
```bash
config status              # Check what's changed
config add -u              # Add all changed files
config commit -m "msg"     # Commit
config push                # Push to GitHub
```

## Daily Usage Alias

Add the `cacp` function to your `.zshrc`:
```bash
cacp() {
    config add -u && config commit -m "$1" && config push  
}
```

Reload your shell configuration:
```bash
source ~/.zshrc
```

Use the `cacp` function for quick updates:
```bash
cacp "your commit message"
```

Example:
```bash
cacp "Updated config files"
```