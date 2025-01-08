eval "$(/opt/homebrew/bin/brew shellenv)"

source "$HOME/.zsh/.env"
source "$HOME/.zsh/.path-modifiers.zsh"

source "$HOME/src/powerlevel10k/powerlevel10k.zsh-theme"
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source "$HOME/.zsh/.p10k.zsh"

source "$HOME/.zsh/tools/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/tools/zshmarks/zshmarks.plugin.zsh"
source "$HOME/.zsh/tools/.omz-git-completions.zsh"
source "$HOME/.zsh/tools/zsh-you-should-use/you-should-use.plugin.zsh"

source "$HOME/.zsh/tools/.reveal-alias.zsh"

source "$HOME/.zsh/aliases/index.zsh"

if [[ "$MY_SYSTEM" == "mac" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$MY_SYSTEM" == "linux" ]]; then
  echo "need to source zsh-syntax-highlighting and update this script"
fi

source <(fx --comp zsh)

. "$XDG_DATA_HOME/cargo/env"
