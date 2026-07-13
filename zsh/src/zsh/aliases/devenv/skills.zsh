# Skill management via skillport (https://github.com/gotalab/skillport).
#
# Skills live under $SKILLS_HOME, organized into three namespaces for at-a-glance
# clarity in the list (skillport protects local edits natively, so namespaces are
# purely organizational):
#   custom/  - skills authored from scratch (author here, or: skillport add <path> --namespace custom)
#   work/    - skills symlinked from a work repo's .github/skills (skLinkWork)
#   lib/     - skills downloaded from external sources (skInstall); updatable via skUpdate
#
# SKILLS_HOME / SKILLPORT_SKILLS_DIR are exported eagerly in path-modifiers.zsh
# (this file is lazy-loaded, so it can't be their reliable source).

alias sk="skillport"
alias skp="skillport"

# Add a downloaded skill (GitHub URL, owner/repo, or built-in) into the lib namespace.
function skillsInstall() {
  skillport add "$@" --namespace lib
}
alias skInstall="skillsInstall"

function skillsList() {
  skillport list "$@"
}
alias skList="skillsList"

function skillsShow() {
  skillport show "$@"
}
alias skShow="skillsShow"

# Regenerate the AGENTS.md skill table.
function skillsSync() {
  skillport doc "$@"
}
alias skSync="skillsSync"

# Update skills from their sources. Locally-edited skills are skipped unless
# --force is passed (skillport refuses to clobber local changes) — that skip is
# the signal to reconcile a customized skill against its upstream.
function skillsUpdate() {
  skillport update "$@"
}
alias skUpdate="skillsUpdate"

function skillsHelp() {
  skillport --help
}
alias skHelp="skillsHelp"

# Symlink a work repo's .github/skills into the work namespace, then resync.
function skillsLinkWork() {
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

  local work_dir="$SKILLS_HOME/work"
  mkdir -p "$work_dir"

  for skill in "$skills_dir"/*(N/); do
    local name=$(basename "$skill")
    local target="$work_dir/$name"

    if [[ -e "$target" ]]; then
      echo "Skipping work/$name (already exists)"
    else
      ln -s "$skill" "$target"
      echo "Linked work/$name"
    fi
  done

  skillsSync
}
alias skLinkWork="skillsLinkWork"
