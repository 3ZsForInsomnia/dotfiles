# Skill management via skillport (https://github.com/gotalab/skillport).
#
# Skills live under $SKILLS_HOME:
#   <root>   - downloaded skills (skInstall); updatable via skUpdate
#   custom/  - skills you author (skillport add <path> --namespace custom); skUpdate
#              leaves untracked skills alone, so these stay put. Shown as custom/<id>.
#
# SKILLS_HOME / SKILLPORT_SKILLS_DIR are exported eagerly in path-modifiers.zsh
# (this file is lazy-loaded, so it can't be their reliable source).

alias sk="skillport"
alias skp="skillport"

# Add a downloaded skill (GitHub URL, owner/repo, or built-in) at the skills root.
function skillsInstall() {
  skillport add "$@"
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

# Regenerate the AGENTS.md skill table in place. skillport swaps only the marked
# SKILLS_TABLE block, so surrounding content is preserved; --force skips the
# confirmation prompt. Output derives from SKILLPORT_SKILLS_DIR's parent so there's
# no second source of truth for the path.
function skillsSync() {
  skillport doc -o "${SKILLPORT_SKILLS_DIR:h}/AGENTS.md" --force "$@"
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
