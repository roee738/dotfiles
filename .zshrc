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

# dotfiles repo
config() {
  local cmd="$1"
  shift || true
  case "$cmd" in
    sync)
      [[ -z "$1" ]] && { echo "Usage: config sync \"message\""; return 1; }
      config add -u && config commit -m "$1" && config push
      ;;
    *)
      /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$cmd" "$@"
      ;;
  esac
}

# school repo
school() {
  local cmd="$1"
  shift || true
  case "$cmd" in
    sync)
      [[ -z "$1" ]] && { echo "Usage: school sync \"message\""; return 1; }
      school add . && school commit -m "$1" && school push
      ;;
    *)
      git -C "$HOME/school" "$cmd" "$@"
      ;;
  esac
}