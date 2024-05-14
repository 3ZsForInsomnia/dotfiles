source () {
    [[ ! "$1.zwc" -nt $1 ]] || zcompile $1
    builtin source $@
}

. () {
    [[ ! "$1.zwc" -nt $1 ]] || zcompile $1
    builtin . $@
}

source "$HOME/.zsh/.source-things.zsh"

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt auto_cd
setopt correct_all
setopt append_history

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done

# Must be sourced after everything else
source "$HOME/code/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
