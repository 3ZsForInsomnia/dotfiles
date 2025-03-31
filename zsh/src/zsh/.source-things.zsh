# Utility to check if a file exists before sourcing it
# Unnecessary for files that are not from hidden gists
check_and_source() {
  local file="$1"
  
  if [[ -f "$file" ]]; then
    source "$file"
  else
    echo "File not found: $file"
    echo "This is likely a missing hidden gist file that you need to insert manually"
  fi
}

eval "$(/opt/homebrew/bin/brew shellenv)"

# This needs to use $HOME since $ZSH_CONFIG_DIR is set in .path-modifiers.zsh
source "$ZSH_CONFIG_DIR/.path-modifiers.zsh"
check_and_source "$ZSH_CONFIG_DIR/.env"

source "$HOME/src/powerlevel10k/powerlevel10k.zsh-theme"
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source "$ZSH_CONFIG_DIR/.p10k.zsh"

source "$ZSH_CONFIG_DIR/tools/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_CONFIG_DIR/tools/zshmarks/zshmarks.plugin.zsh"
source "$ZSH_CONFIG_DIR/tools/.omz-git-completions.zsh"
source "$ZSH_CONFIG_DIR/tools/zsh-you-should-use/you-should-use.plugin.zsh"
source "$ZSH_CONFIG_DIR/tools/.reveal-alias.zsh"

source "$ZSH_CONFIG_DIR/aliases/index.zsh"

if [[ "$MY_SYSTEM" == "mac" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$MY_SYSTEM" == "linux" ]]; then
  echo "need to source zsh-syntax-highlighting and update this script"
fi

source <(fx --comp zsh)

. "$XDG_DATA_HOME/cargo/env"
