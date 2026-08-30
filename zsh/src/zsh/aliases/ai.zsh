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

# --- lbm: delegate grunt work to the local model (codestral via Ollama) ---
# Offloads cheap, high-volume, low-stakes tasks (summarize, classify, extract,
# reformat, draft) to the local model so they don't cost Claude's context. The
# instruction is the positional arg; content is appended from stdin and/or -f FILE
# (repeatable), so large inputs never pass through Claude's window. Prints only the
# model's response. Wrapper functions layer a fixed base instruction on top.
#
#   lbm "summarize the failures, list each as file:line" -f run.log
#   git diff main | lbm "draft a conventional-commit message for this diff"
#   lbm "classify as one of bug|task|story, reply with the label only" -f ticket.md
: "${LBM_MODEL:=codestral:22b-v0.1-q4_0}"
: "${LBM_URL:=http://localhost:11434/api/generate}"
: "${LBM_TEMP:=0.1}"

function lbm() {
  local -a files rest
  while (( $# )); do
    case "$1" in
      -f|--file) files+=("$2"); shift 2 ;;
      *)         rest+=("$1");  shift ;;
    esac
  done

  # Slurp stdin only when it is a real pipe or redirected file. Testing "not a tty"
  # is too broad: non-interactive callers (Claude's shell) attach a char-device
  # stdin that is neither a tty nor EOF, so `cat` would block forever.
  local prompt="${rest[*]}"
  [[ -p /dev/stdin || -f /dev/stdin ]] && prompt+="${prompt:+$'\n\n'}$(cat)"

  local f
  for f in "${files[@]}"; do
    [[ -r "$f" ]] || { print -u2 "lbm: cannot read file: $f"; return 1; }
    prompt+="${prompt:+$'\n\n'}# ${f}"$'\n'"$(<"$f")"
  done

  [[ -n "$prompt" ]] || { print -u2 "lbm: no prompt (give an instruction, pipe input, or -f FILE)"; return 1; }

  local resp
  resp="$(jq -n --arg m "$LBM_MODEL" --arg p "$prompt" --argjson t "$LBM_TEMP" \
            '{model:$m, prompt:$p, stream:false, options:{temperature:$t}}' \
          | curl -sS "$LBM_URL" -d @-)" \
    || { print -u2 "lbm: request to $LBM_URL failed"; return 1; }

  local err
  err="$(print -r -- "$resp" | jq -r '.error // empty')"
  [[ -z "$err" ]] || { print -u2 "lbm: $err"; return 1; }

  # The model tends to prepend a space; strip surrounding whitespace so callers
  # (e.g. classify wrappers whose output gets parsed) get exactly the content.
  local out
  out="$(print -r -- "$resp" | jq -r '.response')"
  out="${out#"${out%%[![:space:]]*}"}"
  out="${out%"${out##*[![:space:]]}"}"
  print -r -- "$out"
}

alias bitch=lbm

# Task wrappers: each bakes in a stable base prompt, then forwards the caller's
# extra instruction and any -f/stdin content to lbm. Compose per call, e.g.
#   lbclass "into one of: bug, task, story" -f ticket.md
#   git diff --staged | lbcommit
lbsum()     { lbm "Summarize concisely. Output only the summary — no preamble, no sign-off." "$@"; }
lbclass()   { lbm "Classify the input into exactly one of the categories I specify. Reply with only the label, nothing else." "$@"; }
lbextract() { lbm "Extract or reformat the data exactly as instructed. Output only the result — no explanation, no code fences." "$@"; }
lbproof()   { lbm "Fix only spelling and grammar. Preserve wording, meaning, and formatting otherwise. Output only the corrected text." "$@"; }
lbcommit()  { lbm "Write a single Conventional Commits message (type(scope): summary, imperative mood) for this diff. Output only the message." "$@"; }
lbpr()      { lbm "Draft a PR description with three sections — Summary, Changes, Test plan. Be concise. Output only the description." "$@"; }
