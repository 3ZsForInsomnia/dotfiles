alias_path="$ZSH_CONFIG_DIR/aliases"

sources=(
  "compilation.zsh"
  "config-utils.zsh"
  "sgpt.zsh"
  "utils.zsh"
  "vectorcode.zsh"
  "makefiles.zsh"
)

for source_file in "${sources[@]}"; do
  if [[ ! -f "$alias_path/$source_file" ]]; then
    echo "Error: $alias_path/$source_file not found."
  else
    source "$alias_path/$source_file"
  fi
done

lazyLoad directory "$HOME/src" "$alias_path/git/index.zsh" "" true
lazyLoad directory "$HOME/Documents/sync" "$alias_path/git/index.zsh" "" true
lazyLoad directory "$HOME/src" "$alias_path/golang.zsh" "" true
lazyLoad directory "$HOME/src" "$alias_path/docker.zsh" "" true
lazyLoad directory "$W_PATH" "$alias_path/kubernetes.zsh" "" true
lazyLoad directory "$W_PATH" "$alias_path/azure.zsh" "" true
lazyLoad directory "$W_PATH" "$alias_path/jira.zsh" "" true
lazyLoad directory "$W_PATH" "$alias_path/db.zsh" "" true
lazyLoad directory "$HOME/src" "$alias_path/ghub.zsh" "" true
lazyLoad directory "$HOME/src" "$alias_path/devenv/index.zsh" "Lazy load devenv utils" true
lazyLoad directory "$HOME/Documents/sync" "$alias_path/devenv/index.zsh" "Lazy load devenv utils" true
lazyLoad directory "$W_PATH" "$alias_path/work/index.zsh" "Lazy load work environment utils" true

# Defer the initial directory check to avoid startup penalty
zsh-defer lazyLoadDeferredCheck

# Background load non-essential aliases with zsh-defer
zsh-defer source "$alias_path/nvim.zsh"
zsh-defer source "$alias_path/searching.zsh"
zsh-defer source "$alias_path/lss.zsh"
zsh-defer source "$alias_path/misc.zsh"
zsh-defer source "$alias_path/python.zsh"
zsh-defer source "$alias_path/js-ts.zsh"
zsh-defer source "$alias_path/lua.zsh"
zsh-defer source "$alias_path/slack.zsh"
zsh-defer source "$alias_path/wezterm.zsh"
zsh-defer source "$alias_path/tui-tools.zsh"
zsh-defer source "$alias_path/dates.zsh"

# Load dash-g.zsh via zsh-defer (aliases work fine, just alias command output is buggy)
zsh-defer source "$alias_path/dash-g.zsh"
