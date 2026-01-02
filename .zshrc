autoload -Uz compinit
compinit -C

export PROMPT="%~ > "

HISTFILE=~/.zsh_history
HISTSIZE=8000
SAVEHIST=8000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Dotfiles repo
config() {
  local cmd="$1"
  shift || true
  case "$cmd" in
    sync)
      if [[ -z "$1" ]]; then
        echo "Usage: config sync \"commit message\""
        return 1
      fi
      config add -u &&
      config commit -m "$1" &&
      config push
      ;;
    *)
      /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$cmd" "$@"
      ;;
  esac
}

# School repo
school() {
  local cmd="$1"
  shift || true
  case "$cmd" in
    sync)
      if [[ -z "$1" ]]; then
        echo "Usage: school sync \"commit message\""
        return 1
      fi
      school add . &&
      school commit -m "$1" &&
      school push
      ;;
    *)
      git -C "$HOME/school" "$cmd" "$@"
      ;;
  esac
}
