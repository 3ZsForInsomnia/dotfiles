# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
export ZSH=/Users/zachary.levine/.oh-my-zsh # Path to your oh-my-zsh installation.
source ~/.path-modifiers.sh

ZSH_THEME="powerlevel10k/powerlevel10k"
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

plugins=(git colored-man-pages zshmarks you-should-use zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# User configuration

source ~/.p10k.zsh # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /Users/zachary.levine/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh/ $fpath)

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

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

source ~/.bashrc

function git_main_branch() {
  def=`git remote show origin | sed -n '/HEAD branch/s/.*: //p'`
  echo $def
}
