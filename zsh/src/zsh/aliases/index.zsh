alias_path="$ZSH_CONFIG_DIR/aliases"

sources=(
  "azure.zsh"
  "dash-g.zsh"
  "db.zsh"
  "docker.zsh"
  "ghub.zsh"
  "git.zsh"
  "golang.zsh"
  "jira.zsh"
  "js-ts.zsh"
  "kubernetes.zsh"
  "lua.zsh"
  "misc.zsh"
  "nvim.zsh"
  "python.zsh"
  "searching.zsh"
  "slack.zsh"
  "tui-tools.zsh"
  "utils.zsh"
  "wezterm.zsh"
  "work/index.zsh"
  "devenv/index.zsh"
)

for source_file in "${sources[@]}"; do
  if [[ ! -f "$alias_path/$source_file" ]]; then
    echo "Error: $alias_path/$source_file not found."
  else
    source "$alias_path/$source_file"
  fi
done
