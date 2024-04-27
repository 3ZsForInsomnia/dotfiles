source "$HOME/.source-things.zsh"

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt auto_cd
setopt correct_all
setopt append_history

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/zsh-completions/src ~/.zsh/ $fpath)

# ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
# ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
# ZVM_VI_HIGHLIGHT_FOREGROUND=#000000
# ZVM_VI_HIGHLIGHT_BACKGROUND=#fe9a4a

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

GPG_TTY=$(tty)
export GPG_TTY

autoload -Uz compinit
compinit

# Must be sourced after everything else
source "$HOME/code/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
