alias img='wezterm imgcat '
alias wezKeys="wezterm show-keys"

alias renameTab="wezterm cli set-tab-title"
alias dotsTab="renameTab dots"
alias notestab="renameTab notes"

alias upgradeWezterm="brew upgrade --cask wezterm@nightly --no-quarantine --greedy-latest"

# Create a layout with a main pane (80%) and two stacked panes on the right (20%)
function wezterm-layout() {
  local main_pane_id
  main_pane_id=$(wezterm cli get-pane-direction right 2>/dev/null)

  if [[ -n "$main_pane_id" ]]; then
    echo "Panes already exist to the right. Run in a tab with a single pane."
    return 1
  fi

  local right_pane_id
  right_pane_id=$(wezterm cli split-pane --right --percent 20)

  wezterm cli split-pane --bottom --percent 50 --pane-id "$right_pane_id" >/dev/null

  wezterm cli activate-pane-direction left
}
alias wtl='wezterm-layout'
