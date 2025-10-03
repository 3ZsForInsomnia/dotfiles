# zmodload zsh/zprof

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/zcompcache"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=("$ZSH_CONFIG_DIR/completions" "~/.zfunc" $fpath)
zmodload zsh/complist
skip_global_compinit=1
autoload -Uz is-at-least

autoload -Uz compinit
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
  compinit -d "${ZSH_COMPDUMP}"
else
  compinit -C -d "${ZSH_COMPDUMP}"
fi

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000

setopt EXTENDED_HISTORY
setopt hist_ignore_dups
setopt share_history
setopt append_history

setopt auto_cd

export CORRECT_IGNORE_FILE='.*|test'
setopt correct_all
setopt no_beep
ZSH_DISABLE_COMPFIX=true

function fancy_history_widget() {
  BUFFER=$(
    \history -r 1 | awk '{$1=""; print substr($0,2)}' |
      fzf --reverse \
        --prompt="History> " \
        --preview '~/src/zsh/tools/pretty-hist-preview.zsh {}'
  )
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N fancy_history_widget
bindkey '^R' fancy_history_widget

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[d" backward-delete-word
bindkey "^[c" delete-word

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source "$ZSH_CONFIG_DIR/source-things.zsh"

# Initialize compilation cache system early
# This will handle .zcompdump and other file compilation intelligently
{
  source "$ZSH_CONFIG_DIR/tools/compilation-cache.zsh"
  # Compile .zcompdump and other files if needed
  [[ -f "$ZSH_COMPDUMP" ]] && {
    [[ ! -f "$ZSH_COMPDUMP.zwc" || "$ZSH_COMPDUMP" -nt "$ZSH_COMPDUMP.zwc" ]] && zcompile "$ZSH_COMPDUMP"
  }
} &!

zstyle ':completion:*' menu select

# Completion styling - show descriptions properly
zstyle ':completion:*' format '%B-- %d --%b'
zstyle ':completion:*:descriptions' format '%B-- %d --%b'
zstyle ':completion:*:warnings' format '%BNo matches found%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Show descriptions on separate line
zstyle ':completion:*' auto-description 'specify: %d'

# Force reload completions (useful for testing)
alias reload-completions='autoload -U compinit && compinit'

# Load help system
zsh-defer source "$ZSH_CONFIG_DIR/tools/help/main.zsh" 2>/dev/null

# zprof
