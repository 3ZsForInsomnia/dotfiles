source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source ~/.path-modifiers.sh

setopt auto_cd
setopt correct_all
setopt append_history

source ~/.p10k.zsh
# source /home/zach/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# source /home/zach/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# source /home/zach/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /home/zach/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /home/zach/zshmarks/zshmarks.plugin.zsh
# source /home/zach/omz-git-completions.zsh
# source /home/zach/zsh-you-should-use/you-should-use.plugin.zsh
source /Users/zachary/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/zachary/zshmarks/zshmarks.plugin.zsh
source /Users/zachary/omz-git-completions.zsh
source /Users/zachary/zsh-you-should-use/you-should-use.plugin.zsh
source /Users/zachary/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/zsh-completions/src ~/.zsh/ $fpath)

source ~/.bashrc

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VI_HIGHLIGHT_FOREGROUND=#000000
ZVM_VI_HIGHLIGHT_BACKGROUND=#fe9a4a

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

XDG_CACHE_HOME=$HOME/.cache
XDG_CONFIG_HOME=$HOME/.config
XDG_DATA_HOME=$HOME/.local/share
XDG_STATE_HOME=$HOME/.local/state

# https://dev.to/equiman/reveal-the-command-behind-an-alias-with-zsh-4d96
local cmd_alias=""

# Reveal Executed Alias
alias_for() {
  [[ $1 =~ '[[:punct:]]' ]] && return
  local search=${1}
  local found="$( alias $search )"
  if [[ -n $found ]]; then
    found=${found//\\//} # Replace backslash with slash
    found=${found%\'} # Remove end single quote
    found=${found#"$search='"} # Remove alias name
    echo "${found} ${2}" | xargs # Return found value (with parameters)
  else
    echo ""
  fi
}

expand_command_line() {
  first=$(echo "$1" | awk '{print $1;}')
  rest=$(echo ${${1}/"${first}"/})

  if [[ -n "${first//-//}" ]]; then # is not hypen
    cmd_alias="$(alias_for "${first}" "${rest:1}")" # Check if there's an alias for the command
    if [[ -n $cmd_alias ]]; then # If there was
      echo "${T_GREEN}❯ ${T_YELLOW}${cmd_alias}${F_RESET}" # Print it
    fi
  fi
}

pre_validation() {
  [[ $# -eq 0 ]] && return                    # If there's no input, return. Else...
  expand_command_line "$@"
}
autoload -U add-zsh-hook
add-zsh-hook preexec pre_validation

# zstyle ':completion:*' menu select
zmodload zsh/complist
# use the vi navigation keys in menu completion
# bindkey '^j' expand-or-complete 
# bindkey -M menuselect '^h' vi-backward-char
# bindkey -M menuselect '^k' vi-up-line-or-history
# bindkey -M menuselect '^l' vi-forward-char
# bindkey -M menuselect '^j' vi-down-line-or-history

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

mkdir -p ~/.local/bin
# ln -s /usr/bin/batcat ~/.local/bin/bat

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/bin:$PATH"
