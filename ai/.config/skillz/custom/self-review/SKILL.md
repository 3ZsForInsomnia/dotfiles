---
name: self-review
description: "Review Zach's own branch before he marks its PR ready for review (or opens one): gather the change and its ticket, review it including uncommitted work, check the PR title and description against what the change actually does, and report fixes to make. Zach picks which findings to fix, then you fix those. Use when Zach says 'self-review', 'review my branch', 'review my changes', or asks for a review before marking a PR ready."
user-invocable: true
---

# Self-review of Zach's branch

A single pass over Zach's current branch, ending in a list of fixes. Findings are fixes for Zach's own code, not comments for someone else. All commands run from inside the repository, on the branch being reviewed.

## 1. Gather the change

**Find the base.** Check whether the branch has a PR:

```sh
gh pr view --json number,baseRefName --jq '"\(.number) \(.baseRefName)"'
```

- **If it has one,** its base branch is the base. The team uses stacked PRs, so the base isn't always `main`. Also run `pr-context <number>`: it prints the PR's title, description, commits, files, and every review thread. Its file list and counts reflect what's pushed, not local work.
- **If it doesn't,** ask Zach for the base branch.

**Get the local change,** committed and uncommitted:

```sh
git fetch --quiet origin <base>
merge_base=$(git merge-base origin/<base> HEAD)
git log --reverse --format='%h %s%n%b' "$merge_base"..HEAD   # commits
git diff --diff-algorithm=myers "$merge_base" HEAD            # committed changes
git diff HEAD                                                 # uncommitted changes to tracked files
git ls-files --others --exclude-standard                      # untracked files
```

Review all of it. Untracked files that look like part of the change count; ones that look unrelated (scratch files, local config) don't, but mention them in case they were meant to be committed.

**Get the ticket.** Look for ticket keys in the branch name, commit messages, and PR description. For each Jira key, run all three; each gives something the others don't:

```sh
acli jira workitem view <KEY> --fields summary,status,description
acli jira workitem view <KEY> --fields issuetype,parent --json | jq -r '"Type: \(.fields.issuetype.name) | Parent: \(.fields.parent | if . then "\(.key) (\(.fields.issuetype.name)): \(.fields.summary)" else "none" end)"'
acli jira workitem comment list --key <KEY> --json | jq -r '.comments[] | "- \(.author): \(.body)"'
```

Fetch the parent the same way only when the ticket alone doesn't explain what's being built and why. For a linked GitHub issue, use `gh issue view <n> --comments`.

## 2. Review

Follow the `reviewing-code` skill: its process, the areas to cover, severity, and how to write up findings. In addition:

- Mark each finding that concerns uncommitted code as `uncommitted`.
- If the PR has open review threads, check whether the current code addresses each one.

## 3. Check the PR title and description

When a PR exists, compare its title and description with what the change does now, including uncommitted work. Flag anything missing, outdated, or wrong, and anything the repo's PR rules (its `CLAUDE.md` and rules files) require that's absent. When no PR exists yet, skip this step.

## 4. Report

Report in chat:

1. **Findings**, most serious first, each written up as `reviewing-code` describes.
2. **Open review threads** the code doesn't yet address, if any.
3. **Title and description issues,** if any.
4. **Untracked files** that may have been meant for the change.

Then ask Zach which findings to fix.

## 5. Fix

Fix only the findings Zach picks, following the coding rules in context. When done, say which findings were fixed and which were left.
