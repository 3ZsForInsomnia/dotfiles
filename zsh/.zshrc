# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source () {
    [[ ! "$1.zwc" -nt $1 ]] || zcompile $1
    builtin source $@
}

. () {
    [[ ! "$1.zwc" -nt $1 ]] || zcompile $1
    builtin . $@
}

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt auto_cd
CORRECT_IGNORE_FILE='.*|test'
setopt correct_all
setopt append_history

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done

# # pnpm
# export PNPM_HOME="/home/zach/.local/share/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# # pnpm end

source "$HOME/.zsh/.source-things.zsh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
[[ ! -f ~/.zsh/.p10k.zsh ]] || source ~/.zsh/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/src/dotfiles/zsh/.zsh/.p10k.zsh.
[[ ! -f ~/src/dotfiles/zsh/.zsh/.p10k.zsh ]] || source ~/src/dotfiles/zsh/.zsh/.p10k.zsh
