alias cst='c && gst' # Clear and get status

### Committing
alias gcom='g commit -m'
alias gagc='ga . && gc'		
alias gibid='g commit -a --amend -C head'		
alias gempty='g commit --allow-empty'
gac() {
  $(ga $1)
  $(gcom $2)
}
gacp() {
  $(gac $1 $2)
  $(ggp)
}
gcomb() { # Checkout new branch and commit
  $(gcob $1)
  $(gcom $2)
}
gcombp() { # Checkout new branch, commit and push
  $(gcomb $1 $2)
  $(ggp)
}
gcomp() { # Commit and push
  $(gcom $1)
  $(ggp)
}
gab() { # Add and checkout new branch
  $(ga $1)
  $(gcob $2)
}
gabc() { # Add, checkout new branch, commit
  $(gab $1 $2)
  $(gcom $3)
}
gabcp() { # Add, checkout new branch, commit, push
  $(gabc $1 $2 $3)
  $(ggp)
}

### Pulling/Updating
alias gmm='gm master'
alias grbmup='gcm && gup'
alias gupfa='gfa && gup'
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
  eval 'pullBranchThenMergeWithIt master'
}
pullMasThenRebase() {
  eval 'pullBranchThenRebaseWithIt master'
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

### Tags
alias gt='git tag'
alias gptags='git push --tags'

### Stashing
# alias gsta='git stash --include-untracked'
alias gstal='gsta && gup'
alias gstala='gstal && gstaa'
alias gstuno='gst -uno' # much faster for large commit histories but doesn't show untracked
alias gstlaan='gstl P | gstaan'
gstaan() {
    if [ -z "$1" ]
    then
        $(git stash apply)
    else
        git stash apply $(git stash list | grep "$1" | cut -d: -f1 | head -n 1)
    fi
}

gstas() {
  if [ -z "$1" ]
  then
      $(g stash -u)
  else
      $(g stash push -u -m "$1")
  fi
}
alias gsta='gstas'

### Diff
alias gdiff='git diff --ignore-all-space | git-split-diffs --color L -RFX'
alias gd='gdiff'

### Cleaning
alias grhhm='grhh origin/master'
alias gbdeleteMerged='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias gbdm='gbdeleteMerged'

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
