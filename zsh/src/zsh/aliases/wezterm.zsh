alias img='wezterm imgcat '
alias wezKeys="wezterm show-keys"

alias renameTab="wezterm cli set-tab-title"
alias dotsTab="renameTab dots"
alias notestab="renameTab notes"

alias upgradeWezterm="brew upgrade --cask wezterm@nightly --no-quarantine --greedy-latest"

# Create a layout: top pane (70%) + bottom pane (30%) split into main left + two stacked right
function wezterm-layout() {
  local pane_below
  pane_below=$(wezterm cli get-pane-direction down 2>/dev/null)

  if [[ -n "$pane_below" ]]; then
    wezterm cli activate-pane-direction down
  fi

  local pane_right
  pane_right=$(wezterm cli get-pane-direction right 2>/dev/null)

  if [[ -n "$pane_right" ]]; then
    echo "Right panes already exist. Run in a tab without right splits."
    return 1
  fi

  local pane_above
  pane_above=$(wezterm cli get-pane-direction up 2>/dev/null)

  if [[ -z "$pane_above" ]]; then
    wezterm cli split-pane --top --percent 80 >/dev/null
  fi

  local right_pane_id
  right_pane_id=$(wezterm cli split-pane --right --percent 20)

  wezterm cli split-pane --bottom --percent 50 --pane-id "$right_pane_id" >/dev/null

  wezterm cli activate-pane-direction left
}
alias wtl='wezterm-layout'
alias wezdev='wezterm-layout'
