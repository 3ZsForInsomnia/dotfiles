source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

fpath=("$ZSH_CONFIG_DIR/completions" $fpath)

zmodload zsh/complist
autoload -Uz compinit
compinit -C ~/.cache/zsh/.zcompdump

export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/zcompcache"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt append_history
setopt auto_cd
setopt correct_all
export CORRECT_IGNORE_FILE='.*|test'

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source "$ZSH_CONFIG_DIR/.source-things.zsh"
