export OSK_HOME="$HOME/.agent/skills"

alias osk="openskills"
alias oskSync='openskills sync -o "$HOME"/.agent/AGENTS.md -y'

function oskInstall() {
  openskills install "$@" --universal --global
}

function oskUpdate() {
  current_dir=$(pwd)
  cd "$OSK_HOME"
  openskills update
  cd "$current_dir"
}

# Used to link OpenSkills from a git repository to the ~/.agent/skills directory
# It will find the .github/skills directory in the current git repository and create symbolic links
#   for each skill in the ~/.agent/skills directory
function oskLink() {
  local project_root
  project_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$project_root" ]]; then
    echo "Error: not in a git repository" >&2
    return 1
  fi

  local skills_dir="$project_root/.github/skills"

  if [[ ! -d "$skills_dir" ]]; then
    echo "Error: no .github/skills directory found in $project_root" >&2
    return 1
  fi

  for skill in "$skills_dir"/*(N/); do
    local name=$(basename "$skill")
    local target="$OSK_HOME/$name"

    if [[ -e "$target" ]]; then
      echo "Skipping $name (already exists)"
    else
      ln -s "$skill" "$target"
      echo "Linked $name"
    fi
  done

  oskSync
}
