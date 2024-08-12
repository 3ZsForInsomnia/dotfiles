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
alias cst='c && gst'    # Clear and get status
alias gstuno='gst -uno' # much faster for large commit histories but doesn't show untracked

alias currBranch='git rev-parse --abbrev-ref HEAD PC'

### Committing
alias gibid='g commit -a --amend -C head'
alias gce='g commit --allow-empty'
alias gc='g commit -v -m'
gac() {
  if [ -z "$2" ]; then
    location="."
  else
    location=$2
  fi

  $(ga $location)
  $(gc $1)
}
gacp() {
  if [ -z "$2" ]; then
    location="."
  else
    location=$2
  fi

  $(gac "$1" "$location")
  $(ggp)
}
gcbc() { # Checkout new branch and commit
  $(gco $1)
}
# What is arg 2?
gcbcp() { # Checkout new branch, commit and push
  $(gcbc $1 $2)
  $(ggp)
}
gab() { # Add and checkout new branch
  if [ -z "$2" ]; then
    location="."
  else
    location=$2
  fi

  $(ga $location)
  $(gco $1)
}
# 1 = branch, 2 = message, 3 = directory/path
gacbc() { # Add, checkout new branch, commit
  $(gab $1 $3)
  $(gc $2)
}
gacbcp() { # Add, checkout new branch, commit, push
  $(gabc $1 $2 $3)
  $(ggp)
}

### Pulling/Updating
alias garbc="git add . && git rebase --continue"

function grbh() {
  $(git rebase --interactive HEAD~"$1")
}
# alias gmm='gm $(git_main_branch)'

alias gfapu='gfa && gup'
alias gfapm='gfa && gup && gcm'
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
  if [ -z "$1" ]; then
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
  if [ -z "$1" ]; then
    $(git stash apply)
  elif [ "$1" = <- >]; then
    git stash pop stash@{$1}
  else
    git stash apply $(git stash list | grep "$1" | cut -d: -f1 | head -n 1)
  fi
}
# List stashes in Peco, and apply the selected stash if any is chosen
function gstala() {
  a=$(gstl P)
  if [ -n "$a" ]; then
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
  $(stashThenRunAndApply pullMasThenMerge)
}
stashRebaseMas() {
  $(stashThenRunAndApply pullMasThenRebase)
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
  # eval 'gcb levine/$1'
  eval 'gcb $1'
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
  eval 'gco zl-$1'
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
  echo $(git rev-parse --abbrev-ref HEAD)
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
  git config --global alias.ctags '!.git/hooks/ctags'
  git config --global init.templatedir '~/.git_template'
}

### FZF-based git helpers
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --tac +s +m -e) &&
    git checkout $(echo "$commit" | sed "s/ .*//")
}
# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "$branches" |
      fzf-tmux -d $((2 + $(wc -l <<<"$branches"))) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" |
      sed '/^$/d'
  ) || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}'
  ) || return
  target=$(
    (
      echo "$branches"
      echo "$tags"
    ) |
      fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'"
  ) || return
  git checkout $(awk '{print $2}' <<<"$target")
}
# fcoc_preview - checkout git commit with previews
fcoc_preview() {
  local commit
  commit=$(glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
      --ansi --preview="$_viewGitLogLine") &&
    git checkout $(echo "$commit" | sed "s/ .*//")
}
# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
      fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b
  ); do
    mapfile -t out <<<"$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break
    else
      git stash show -p $sha
    fi
  done
}
