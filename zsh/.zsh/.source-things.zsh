source "$HOME/.zsh/.env"
source "$HOME/.zsh/.path-modifiers.zsh"

source "$HOME/src/powerlevel10k/powerlevel10k.zsh-theme"
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source "$HOME/.zsh/.p10k.zsh"

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zshmarks/zshmarks.plugin.zsh"
source "$HOME/.zsh/.omz-git-completions.zsh"
source "$HOME/.zsh/zsh-you-should-use/you-should-use.plugin.zsh"

source "$HOME/.zsh/.reveal-alias.zsh"
source "$HOME/.zsh/.cli-tools.zsh"

source "$HOME/.zsh/aliases/index.zsh"

if [[ "$MY_SYSTEM" == "mac" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$MY_SYSTEM" == "linux" ]]; then
  echo "need to source zsh-syntax-highlighting and update this script"
fi
