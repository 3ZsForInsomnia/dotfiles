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
# Aggressive compaudit caching for performance (eliminates 17ms/55% of startup time)
# Use -C (skip security check) by default, run compaudit occasionally in background
compinit -C -d "${ZSH_COMPDUMP}"

# Run compaudit in background occasionally (weekly or when completion files change)
{
  # Only run compaudit if cache is old or doesn't exist
  local compaudit_cache="$ZSH_CACHE_DIR/compaudit-check"
  local cache_age_limit=$((7 * 24 * 60 * 60))  # 1 week in seconds
  
  if [[ ! -f "$compaudit_cache" ]] || 
     (( $(date +%s) - $(stat -f %m "$compaudit_cache" 2>/dev/null || echo 0) > cache_age_limit )); then
    # Run compaudit and cache results
    mkdir -p "$ZSH_CACHE_DIR"
    compaudit > "$compaudit_cache" 2>&1
    # Touch the cache file to update timestamp
    touch "$compaudit_cache"
  fi
} &!

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000

setopt EXTENDED_HISTORY
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt share_history
setopt append_history

setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd

setopt noflowcontrol
setopt longlistjobs
setopt notify
setopt completeinword
setopt extended_glob

export CORRECT_IGNORE_FILE='dotfiles|.*|test'
setopt correct_all
alias git='nocorrect git'
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

# Bind Home/End keys
bindkey "^[[H" beginning-of-line # Home
bindkey "^[[F" end-of-line       # End

# Bind Alt + Arrow keys for word-wise navigation
bindkey "^[[1;3D" backward-word  # Alt+LeftArrow
bindkey "^[[1;3C" forward-word   # Alt+RightArrow

# Custom word-wise deletion
bindkey "^[d" backward-delete-word # Alt+d (deletes word backward)
bindkey "^[c" delete-word          # Alt+c (deletes word forward)

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
