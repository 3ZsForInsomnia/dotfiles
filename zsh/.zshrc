source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source ~/.path-modifiers.sh

ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"

source ~/.p10k.zsh
source /Users/zachary.levine/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/zachary.levine/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /Users/zachary.levine/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/zachary.levine/zshmarks/zshmarks.plugin.zsh
source /Users/zachary.levine/omz-git-completions.zsh
source /Users/zachary.levine/zsh-you-should-use/you-should-use.plugin.zsh
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/zsh-completions/src ~/.zsh/ $fpath)

source ~/.bashrc

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# bindkey '^ ' autosuggest-accept

bindkey -M menuselect '^[h' vi-backward-char
bindkey -M menuselect '^[l' vi-forward-char
bindkey '^[k' up-line-or-search
bindkey '^[k' up-line-or-history
bindkey '^[j' down-line-or-select
bindkey '^[j' down-line-or-history

function git_main_branch() {
  def=`git remote show origin | sed -n '/HEAD branch/s/.*: //p'`
  echo $def
}

# Personal automation/logging completions
alias cli='nocorrect cli'

_cli_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cli --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _cli_yargs_completions cli
###-end-cli-completions-###

source ~/powerlevel10k/powerlevel10k.zsh-theme
