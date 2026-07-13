alias ai='sgpt'
alias ais='sgpt --shell'
alias aip='sgpt --code'
alias aic='sgpt --chat'
alias ail='sgpt --list-chats'
alias aih='sgpt --show-chat'
alias air='sgpt --repl'

function aipy() {
  local prompt="$1"

  sgpt --code "$prompt using python"
}

alias lama-restart="launchctl kickstart -k gui/$(id -u)/com.user.ollama"

# --- skillport: skill management (https://github.com/gotalab/skillport) ---
# Skills live under $SKILLS_HOME (set in path-modifiers.zsh): downloaded skills at the
# root; custom/ holds skills you author (skUpdate leaves untracked skills alone).
alias sk="skillport"
alias skAdd="sk add"        # add a skill: GitHub URL, owner/repo, or builtin
alias skList="sk list"
alias skShow="sk show"      # print a skill's full instructions
alias skUpdate="sk update"  # refresh downloaded skills from their source
alias skHelp="sk --help"

# Regenerate ~/.agent/AGENTS.md in place; skillport swaps only its marked block.
# Path derives from SKILLPORT_SKILLS_DIR so there's no second source of truth.
function skSync() {
  skillport doc -o "${SKILLPORT_SKILLS_DIR:h}/AGENTS.md" --force "$@"
}
