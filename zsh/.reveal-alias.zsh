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

zstyle ':completion:*' menu select
zmodload zsh/complist

function git_main_branch() {
  def=`git remote show origin | sed -n '/HEAD branch/s/.*: //p'`
  echo $def
}
