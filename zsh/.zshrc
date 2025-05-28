# zmodload zsh/zprof

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/zcompcache"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=("$ZSH_CONFIG_DIR/completions" $fpath)
zmodload zsh/complist
skip_global_compinit=1
autoload -Uz is-at-least

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
export CORRECT_IGNORE_FILE='.*|test'

setopt append_history
setopt auto_cd
setopt correct_all
setopt no_beep
ZSH_DISABLE_COMPFIX=true

bindkey '^R' history-incremental-search-backward
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[d" backward-delete-word
bindkey "^[c" delete-word

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source "$ZSH_CONFIG_DIR/.source-things.zsh"

# Compile .zcompdump in the background
{
  local zcompdump="${ZSH_COMPDUMP}"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# zprof
