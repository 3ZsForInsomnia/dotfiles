source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source "$HOME/.zsh/.p10k.zsh"
source "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"

source "$HOME/.zsh/.path-modifiers.zsh"

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zshmarks/zshmarks.plugin.zsh"
source "$HOME/.zsh/.omz-git-completions.zsh"
# source "$HOME/.zsh/zsh-you-should-use/you-should-use.plugin.zsh"

# source "$HOME/.zsh/.reveal-alias.zsh"
source "$HOME/.zsh/.cli-tools.zsh"

zstyle ':completion:*:*:git:*' script ~/.zsh/.git-completion.bash
fpath=(~/.zsh/completions/ $fpath)

source "$HOME/.bashrc"
