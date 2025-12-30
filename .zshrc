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
alias config='/usr/bin/git --git-dir=/home/roee/.dotfiles/ --work-tree=/home/roee'
cacp() {
    config add -u && config commit -m "$1" && config push  
}
alias school='git -C /home/roee/school'
sacp() {
    school add . && school commit -m "$1" && school push  
}
