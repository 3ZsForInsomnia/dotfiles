#!/usr/bin/env zsh

# Commitizen Integration
# Conventional commits with commitizen CLI

### Basic Commitizen Aliases

alias cz='cz'
alias czr='cz --retry'

### Git Add + Commitizen

function gacz() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gacz [files]"
    echo "Git add + commitizen"
    echo "Examples:"
    echo "  gacz           # Add all, then run cz"
    echo "  gacz file.js   # Add file.js, then run cz"
    return 0
  fi

  if [[ -z "$1" ]]; then
    ga
  else
    ga "$@"
  fi
  cz
}

function gaczr() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gaczr [files]"
    echo "Git add + commitizen --retry"
    echo "Retry last commitizen commit"
    echo "Examples:"
    echo "  gaczr           # Add all, then run cz --retry"
    echo "  gaczr file.js   # Add file.js, then run cz --retry"
    return 0
  fi

  if [[ -z "$1" ]]; then
    ga
  else
    ga "$@"
  fi
  cz --retry
}

### Git Add + Commitizen + Push

function gaczp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gaczp [-r] [-n] [files]"
    echo "Git add + commitizen + push"
    echo "Options:"
    echo "  -r  Pass --retry to commitizen"
    echo "  -n  Pass --no-verify to commitizen"
    echo "Examples:"
    echo "  gaczp                # Add all, cz commit, push"
    echo "  gaczp file.js        # Add file.js, cz commit, push"
    echo "  gaczp -r             # Add all, cz commit with retry, push"
    echo "  gaczp -n file.js     # Add file.js, cz commit with no-verify, push"
    echo "  gaczp -r -n          # Add all, cz commit with retry and no-verify, push"
    return 0
  fi

  local retry=false
  local no_verify=false
  local files=()

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -r)
      retry=true
      shift
      ;;
    -n)
      no_verify=true
      shift
      ;;
    *)
      files+=("$1")
      shift
      ;;
    esac
  done

  # Git add
  if [[ ${#files[@]} -eq 0 ]]; then
    ga
  else
    ga "${files[@]}"
  fi

  # Build cz command
  local cz_cmd="cz"
  if [[ "$retry" == true ]]; then
    cz_cmd="$cz_cmd --retry"
  fi
  if [[ "$no_verify" == true ]]; then
    cz_cmd="$cz_cmd --no-verify"
  fi

  # Run commitizen
  eval "$cz_cmd" || return 1

  # Push
  gp
}

function gaczrp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: gaczrp [files]"
    echo "Git add + commitizen --retry + push"
    echo "Examples:"
    echo "  gaczrp           # Add all, retry cz, push"
    echo "  gaczrp file.js   # Add file.js, retry cz, push"
    return 0
  fi

  if [[ -z "$1" ]]; then
    ga
  else
    ga "$@"
  fi
  cz --retry || return 1
  gp
}

### Commitizen + Push (no add)

function czp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: czp"
    echo "Commitizen + push (assumes files already staged)"
    return 0
  fi

  cz && gp
}

function czrp() {
  if [[ "$1" == "-h" ]]; then
    echo "Usage: czrp"
    echo "Commitizen --retry + push"
    return 0
  fi

  cz --retry && gp
}
