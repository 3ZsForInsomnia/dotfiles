#compdef dates.js
###-begin-dates.js-completions-###
#
# yargs command completion script
#
# Installation: /Users/zachary/.local/bin/dates.js completion >> ~/.zshrc
#    or /Users/zachary/.local/bin/dates.js completion >> ~/.zprofile on OSX.
#
_dates.js_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" $HOME/.local/bin/dates.js --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _dates.js_yargs_completions dates.js
###-end-dates.js-completions-###

#compdef hrvst
###-begin-hrvst-completions-###
#
# yargs command completion script
#
# Installation: /Users/zachary/.local/share/.npm-packages/bin/hrvst completion >> ~/.zshrc
#    or /Users/zachary/.local/share/.npm-packages/bin/hrvst completion >> ~/.zprofile on OSX.
#
_hrvst_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" $HOME/.local/share/.npm-packages/bin/hrvst --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _hrvst_yargs_completions hrvst
###-end-hrvst-completions-###

