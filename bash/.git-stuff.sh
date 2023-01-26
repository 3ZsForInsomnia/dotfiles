### Convention
# g -> git
# st -> status
# a -> add (or apply if used with stash)
# c -> commit
# co -> checkout
# cb -> checkout new branch
# cm -> checkout git_main_branch
# p -> push
# pu -> pull
# m -> merge
# r -> rebase
# f -> fetch
# fa -> fetch all
# t -> tags
# d -> delete
# sta -> stash
# d -> diff

### Status
alias cst='c && gst' # Clear and get status
alias gstuno='gst -uno' # much faster for large commit histories but doesn't show untracked

### Committing
alias gibid='g commit -a --amend -C head'		
alias gce='g commit --allow-empty'
alias gc='g commit -v -m'
gac() {
  $(ga $1)
  $(gc $2)
}
gacp() {
  $(gac $1 $2)
  $(ggp)
}
gcbc() { # Checkout new branch and commit
  $(gco $1)
}
gcbcp() { # Checkout new branch, commit and push
  $(gcbc $1 $2)
  $(ggp)
}
gab() { # Add and checkout new branch
  $(ga $1)
  $(gco $2)
}
gacbc() { # Add, checkout new branch, commit
  $(gab $1 $2)
  $(gc $3)
}
gacbcp() { # Add, checkout new branch, commit, push
  $(gabc $1 $2 $3)
  $(ggp)
}

### Pulling/Updating
alias gmm='gm $(git_main_branch)'
alias gcmpu='gcm && gup'
alias gfapu='gfa && gup'
pullBranchThenMergeWithIt() {
  currentBranch=$(git symbolic-ref --short HEAD)
  $(gco $1)
  $(ggl)
  $(gco $currentBranch)
  $(git merge $1)
}
pullBranchThenRebaseWithIt() {
  $(gsta)
  currentBranch=$(git symbolic-ref --short HEAD)
  $(gco $1)
  $(gup)
  $(gco $currentBranch)
  $(grb $1)
  $(gstaa)
}
pullMasThenMerge() {
  eval 'pullBranchThenMergeWithIt $(git_main_branch)'
}
pullMasThenRebase() {
  eval 'pullBranchThenRebaseWithIt $(git_main_branch)'
}
alias gpmm='pullMasThenMerge'
alias gprm='pullMasThenRebase'

### Tags
alias gt='git tag'
alias gpt='git push --tags'

### Stashing
function gstas() { # Stash with name if available, otherwise just stash
  if [ -z "$1" ]
  then
      $(g stash -u)
  else
      $(g stash push -u -m "$1")
  fi
}
alias gsta='gstas'
alias gstapu='gsta && gup'
alias gstapua='gstapu && gstaa'
# git stash apply with name if present, or apply stash by number if input is number (for gstala)
function gstaa() { 
  if [ -z "$1" ]
  then
    $(git stash apply)
  elif [ "$1" = <-> ]
  then
    git stash pop stash@{$1}
  else
    git stash apply $(git stash list | grep "$1" | cut -d: -f1 | head -n 1)
  fi
}
function gstala() {
  a=$(gstl P)
  if [ -n "$a" ]
  then
    b=$(echo $a C -d: -f1 TR -dc '0-9')
    $(gstaa $b)
  fi
}
stashThenRunAndApply() {
  $(gsta)
  eval $1
  $(gstaa)
}
stashMergeMas() {
  $(stashThenRunAndApply(pullMasThenMerge))
}
stashRebaseMas() {
  $(stashThenRunAndApply(pullMasThenRebase))
}
alias gstamm='stashMergeMas'
alias gstarm='stashRebaseMas'

### Diff
alias gd='git diff --ignore-all-space | git-split-diffs --color L -RFX'

### Cleaning
alias grhhm='grhh origin/$(git_main_branch)'
alias deleteMerged='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'
alias gdm='deleteMerged'

### Branches
gcob() {
  eval 'gcb levine/$1'
}
feat() {
  eval 'gcb feature/$1'
}
fix() {
  eval 'gcb fix/$1'
}
chore() {
  eval 'gcb chore/$1'
}
refactor() {
  eval 'gcb refactor/$1'
}
docs() {
  eval 'gcb docs/$1'
}
style() {
  eval 'gcb style/$1'
}
# test() {
#   eval 'gcb test/$1'
# }
gcoo() {
  eval 'gco levine/$1'
}

### Revert and log
alias gundo='g revert'
alias gpr='g pull-request'
alias lgl='glog --color=always L'
alias lg='glg --color=always L'

### Misc
alias localGitIgnore='v ~/.gitignore_global'
alias gpause='git add . && git cm "<back>" --no-verify'		
alias gback='git reset HEAD~1'		

### Conventional Commits
# alias gcz='git cz'
# gczpr() {
#   eval 'ga . && gcob $1 && git cz && ggp && gpr'
# }

# alias gacz='ga . && gcz'
# alias gaczp='gacz && ggp'

# alias gaczpmr='gacz && gaczpmrPostCommit'

# gaczpmrPostCommit() {
#     mrURLIfNotPushedYet=$(python ~/gaczpmr.py)
#     if [ -n "$mrURLIfNotPushedYet" ]
#     then
#         echo 'Pushing...'
#         $(ggp)
#         echo 'Opening MR url'
#         $(open $mrURLIfNotPushedYet)
#     else
#         echo 'Pushing...'
#         $(ggp)
#     fi
#     echo 'Done!'
# }

function git_current_branch() {
  local ref
  ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}
function ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git push origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git push origin "${b:=$1}"
  fi
}

### Gists
alias getGistID='gist --list | peco | cut -d "/" -f 4 | cut -d " " -f 1'
gistu() {
  gist_id=$(getGistID)
  eval 'gist -u $gist_id $1'
}
gistr() {
  gist_id=$(getGistID)
  eval 'gist -r $gist_id | setclip'
}

setupGit() {
  git config --global alias.ctags '!.git/hooks/ctags';
  git config --global init.templatedir '~/.git_template'
}
