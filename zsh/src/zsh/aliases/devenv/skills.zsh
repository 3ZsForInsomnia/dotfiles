export SKILLS_HOME="$HOME/.agent/skills"
export SKILLS_BACKEND="skillport"

alias osk="openskills"
alias skp="skillport"

function _skillsCmd() {
  if [[ "$SKILLS_BACKEND" == "skillport" ]]; then
    echo "skillport"
  else
    echo "openskills"
  fi
}

alias sk='$(_skillsCmd)'

function skillsInstall() {
  if [[ "$SKILLS_BACKEND" == "skillport" ]]; then
    skillport add "$@"
  else
    openskills install "$@" --universal --global
  fi
}
alias skInstall="skillsInstall"

function skillsList() {
  if [[ "$SKILLS_BACKEND" == "skillport" ]]; then
    skillport list "$@"
  else
    openskills list "$@"
  fi
}
alias skList="skillsList"

function skillsShow() {
  if [[ "$SKILLS_BACKEND" == "skillport" ]]; then
    skillport show "$@"
  else
    openskills read "$@"
  fi
}
alias skShow="skillsShow"

function skillsSync() {
  if [[ "$SKILLS_BACKEND" == "skillport" ]]; then
    skillport doc "$@"
  else
    openskills sync -o "$HOME"/.agent/AGENTS.md -y "$@"
  fi
}
alias skSync="skillsSync"

function skillsUpdate() {
  if [[ "$SKILLS_BACKEND" == "skillport" ]]; then
    skillport update "$@"
  else
    local current_dir=$(pwd)
    cd "$SKILLS_HOME"
    openskills update "$@"
    cd "$current_dir"
  fi
}
alias skUpdate="skillsUpdate"

function skillsHelp() {
  if [[ "$SKILLS_BACKEND" == "skillport" ]]; then
    skillport --help
  else
    openskills -h
  fi
}
alias skHelp="skillsHelp"

# Link skills from a git repo's .github/skills to ~/.agent/skills (openskills only)
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
    local target="$SKILLS_HOME/$name"

    if [[ -e "$target" ]]; then
      echo "Skipping $name (already exists)"
    else
      ln -s "$skill" "$target"
      echo "Linked $name"
    fi
  done

  skillsSync
}
