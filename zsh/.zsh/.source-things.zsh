source "$HOME/.zsh/.path-modifiers.zsh"

source "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source "$HOME/.zsh/.p10k.zsh"

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zshmarks/zshmarks.plugin.zsh"
source "$HOME/.zsh/.omz-git-completions.zsh"
source "$HOME/.zsh/zsh-you-should-use/you-should-use.plugin.zsh"

source "$HOME/.zsh/.reveal-alias.zsh"
source "$HOME/.zsh/.cli-tools.zsh"

source "$HOME/.bashrc"

# Must be sourced after everything else
source "$HOME/code/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
