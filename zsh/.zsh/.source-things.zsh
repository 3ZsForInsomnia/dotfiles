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

source "$HOME/.bashrc"

source "$HOME/.zsh/aliases/index.zsh"

# Must be sourced after everything else
# source "$HOME/code/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"
