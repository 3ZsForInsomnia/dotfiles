#!/usr/bin/env zsh

entry="$1"
histfile="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"

raw=$(grep --text -F -- "$entry" "$histfile" | tail -1)

if [[ "$raw" =~ ^: ]]; then
  # Remove the first colon and any leading space (" : ....")
  raw="${raw#: }"

  # Split the line at the first ';'
  meta="${raw%%;*}"          # "1718531781:0"
  cmd="${raw#*;}"            # everything after the first semicolon

  # meta format: "timestamp:exitcode"
  ts="${meta%%:*}"           # "1718531781"
  exit_code="${meta##*:}"    # "0"

  # Format the timestamp
  time_str=$(date -d "@$ts" +"%Y-%m-%d %H:%M:%S" 2>/dev/null \
           || date -r "$ts" +"%Y-%m-%d %H:%M:%S" 2>/dev/null \
           || echo "<unknown>")
  
  echo -e "\e[1mTime:\e[0m      $time_str"
  echo -e "\e[1mExit Code:\e[0m $exit_code"
  echo
  echo -e "\e[1mOriginal:\e[0m"
  echo "$cmd" | bat --language bash --style plain --color always
  echo
  echo -e "\e[1mVariables Expanded:\e[0m"
  print -rl -- ${(e):-${cmd}} | bat --language bash --style plain --color always
else
  echo "No EXTENDED_HISTORY data for this entry."
fi
