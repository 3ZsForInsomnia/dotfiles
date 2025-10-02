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
  "sgpt.zsh"
  "slack.zsh"
  "tui-tools.zsh"
  "utils.zsh"
  "wezterm.zsh"
  "devenv/index.zsh"
  # "work/index.zsh"
)

for source_file in "${sources[@]}"; do
  if [[ ! -f "$alias_path/$source_file" ]]; then
    echo "Error: $alias_path/$source_file not found."
  else
    source "$alias_path/$source_file"
  fi
done

lazyLoad directory "~/src" "$alias_path/git/index.zsh"
lazyLoad directory "$W_PATH" "$alias_path/work/index.zsh" "Lazy load work environment utils"
