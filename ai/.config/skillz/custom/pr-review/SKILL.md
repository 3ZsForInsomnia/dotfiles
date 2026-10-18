---
name: pr-review
description: "Review someone else's GitHub PR together with Zach while he reads it in Octo (the Neovim GitHub plugin). Runs a pre-review (marks generated, deleted, binary, and trivial files as viewed; reports obvious issues; suggests a reading order), gives per-file notes and summaries as Zach moves through files, then does an independent second-round review including a critique of Zach's pending comments, and ends with a discussion and a summary of what's left. Use when Zach asks to review a PR, says 'review PR <n>', or opens a review in Octo and asks for help."
user-invocable: true
---

# PR review with Zach

Zach reviews the PR himself in Octo; you work alongside him from a chat in the same Neovim. The review has five stages, in order:

1. **Pre-review**, which you run while Zach does his own pre-reading: gather context (PR data and ticket), mark files that need no review as viewed, then report obvious issues and a suggested reading order.
2. **Zach's first round:** he reviews file by file; for each file you give its notes, threads, and a summary when the diff is large.
3. **Your second round:** a full independent review, plus a critique of Zach's pending comments.
4. **Discussion:** Zach decides what to do with each finding.
5. **Post-review summary:** what's left before he submits.

Never submit the review or post comments yourself: Zach submits from Octo once the review is finished.

All commands run from inside the PR's repository. `gh` placeholders `{owner}` and `{repo}` resolve to that repository automatically.

## Setup

1. **Find the PR number.** In order, stop at the first that works:
   1. the number Zach gives;
   2. Octo's PR buffer, `octo://<owner>/<repo>/pull/<number>` (see "Reading Neovim" below);
   3. the review ID in an Octo review buffer name (`octo://<owner>/<repo>/review/<review-id>/...`), which is GitHub's ID for the review:
      ```sh
      gh api graphql -f id=<review-id> -f query='query($id: ID!) { node(id: $id) { ... on PullRequestReview { pullRequest { number } } } }' --jq '.data.node.pullRequest.number'
      ```
   4. ask Zach.
2. **Open the notes file:**
   ```sh
   pr-notes <number>
   ```
   It prints the path of `~/.local/share/pr-reviews/<owner>-<repo>-<number>.md` and its contents, creating it with empty sections first if it doesn't exist. If it says `existing`, this is a re-review: read what it printed before anything else and treat its decisions as settled unless the code they concern has changed.

The notes file is the durable record of the review: it survives chat compaction (older messages replaced by a summary) and later sessions. Fill its sections as each stage produces content:

- `## Pre-review`: marked-viewed files with the reason for each trivial one, obvious issues, suggested order.
- `## Files`: one `### <path>` subsection per file with your notes on it.
- `## Investigations`: what was looked into beyond the PR itself and what it found, with `file:line` or links.
- `## Second round`: your review findings and your critique of Zach's comments.
- `## Decisions`: what Zach decided about each finding (comment, drop, defer) and why.
- `## Post-review summary`: what was left at the end of the review.

## Reading Neovim

You run as a child process of Zach's Neovim, so `$NVIM` holds its server address. Read state only; never send commands that change anything in his editor.

Every window in every tab, with its buffer name and visible line range:

```sh
nvim --server "$NVIM" --remote-expr 'json_encode(map(nvim_list_wins(), {_, w -> {"tab": nvim_tabpage_get_number(nvim_win_get_tabpage(w)), "buf": bufname(winbufnr(w)), "top": line("w0", w), "bottom": line("w$", w)}}))'
```

Octo PR buffers that are loaded (gives the PR number):

```sh
nvim --server "$NVIM" --remote-expr 'json_encode(filter(map(getbufinfo(), {_, b -> b.name}), {_, n -> n =~# "^octo://.*/pull/[0-9]\\+$"}))'
```

Octo's buffer names:

- `octo://<owner>/<repo>/pull/<number>`: the PR's overview buffer.
- `octo://<owner>/<repo>/review/<review-id>/file/<LEFT|RIGHT>/<path>`: one side of a file's diff in the review. `LEFT` is the base version, `RIGHT` the PR's version. The file Zach is reading is the `<path>` in these names; when both sides are visible they name the same file.
- `octo://<owner>/<repo>/review/<review-id>/threads/<side><path>:<line>`: a comment thread at that line.

Zach's cursor is always in the chat, so cursor position says nothing about what he's reading. Use the visible line range of the `RIGHT` window to know which part of a file he's looking at. Don't read Octo's internal Lua state unless there's information you need that buffer names, visible ranges, and `gh` cannot give; if you think you need it, ask Zach first.

## Stage 1: Pre-review

Zach reads the PR description, the ticket, and the file list in Octo while this runs, so don't wait for him and don't ask questions you can answer from the data.

### 1. Gather context

```sh
pr-context <number>
```

It prints a markdown bundle: title, state, author, branches, the full head and merge-base SHAs, possible ticket keys, linked GitHub issues, the description, commits, each changed file (change type, +/- counts as GitHub shows them, viewed state, its last 3 commits before the PR, existing tests for it), and every review thread including resolved ones.

Then fetch the ticket, every time one is referenced:

- **Jira:** for each real ticket key in "Possible ticket keys" (ignore matches that aren't tickets, like `UTF-8`), run all three; each gives something the others don't:
  ```sh
  acli jira workitem view <KEY> --fields summary,status,description
  acli jira workitem view <KEY> --fields issuetype,parent --json | jq -r '"Type: \(.fields.issuetype.name) | Parent: \(.fields.parent | if . then "\(.key) (\(.fields.issuetype.name)): \(.fields.summary)" else "none" end)"'
  acli jira workitem comment list --key <KEY> --json | jq -r '.comments[] | "- \(.author): \(.body)"'
  ```
  Fetch the parent the same way only when the ticket alone doesn't explain what's being built and why.
- **GitHub issues:** for each linked issue, `gh issue view <n> --comments`.

To see a file's diff exactly as GitHub shows it, using the SHAs from the `pr-context` header:

```sh
git diff --diff-algorithm=myers <merge-base> <head> -- <path>...
```

To read a file as of the PR: `git show <head>:<path>`. Nothing is checked out; `pr-context` already fetched the PR's commits.

### 2. Mark files viewed

Viewed marks are private to Zach and GitHub clears them on any file a later push changes, so mark without asking. Make exactly one call to `pr-mark-viewed`:

1. Collect the files that never need review:
   ```sh
   known=("${(@f)$(pr-known-files <number>)}")
   ```
   This lists deleted files, binary files, and files tagged `linguist-generated` or `linguist-vendored` by the repo's `.gitattributes` or Zach's global git attributes (lockfiles, checksum files).
2. Read the diffs of the remaining files that are still unviewed and pick the trivial ones. A file is trivial only when its entire diff is mechanical, with nothing to judge:
   - a barrel or index file that only adds, removes, or reorders re-exports;
   - import changes only: reordering, or updating paths after a move or rename;
   - threading a new argument, prop, or field through unchanged, with no logic using it in this file;
   - a pure rename or move with no content change beyond imports;
   - formatting or whitespace only.

   Any added or changed logic, condition, type, value, or test assertion makes a file non-trivial. When unsure, it's not trivial.
3. Mark everything at once:
   ```sh
   pr-mark-viewed <number> "${known[@]}" <trivial paths...>
   ```

Then tell Zach in one line that marking is done and how many files were marked, so he knows whether what he sees in Octo includes the marks. Octo only loads viewed state when a review opens: if he opened the review before marking finished, he needs to close and reopen it to see the marks.

### 3. Report obvious issues, then a suggested order

Find the issues that are cheap to spot from the whole PR, before any deep reading:

- bugs and likely regressions, including a change in one file that breaks how another file uses it;
- security problems;
- performance problems;
- violations of the coding rules with no comment or visible reason, labeled the way `reviewing-code` describes (including `personal rule`).

Keep the list to issues worth a reviewer's attention; deeper review happens in stage 3. Point at each issue with up to three line ranges (`path:12-18`); when it spans more than that, list the files involved instead.

Report in chat in this order:

1. **Obvious issues**, most serious first. Each: where, what's wrong, why it matters.
2. **Suggested order** for reading the remaining unviewed files, with a few words on why for each group (e.g. core logic first, then its callers). Put each file's tests right after the file itself, never in a separate group at the end.

Write the marked-viewed list, the issues, and the order to the notes file.

## Stage 2: Zach's first round

Zach reviews file by file in Octo. When he says "next" or otherwise asks about the file he's on:

1. Read the open windows (see "Reading Neovim") and take the file path from the `RIGHT` review buffer. If there isn't one, ask which file.
2. Reread that file's subsection in the notes file and its pre-review issues; don't rely on what's earlier in the chat.
3. Reply with:
   - the pre-review issues for this file, if any;
   - its review threads from `pr-context`, open ones first (rerun `pr-context` if threads may have changed since);
   - when its diff has 70 or more changed lines (additions plus deletions), a short summary of what the change does and how it's structured, so Zach goes in knowing more than the file name.

Answer whatever else he asks about the file: explain a hunk using its commits, the description, and the ticket; find related code; draft a comment. Record anything learned that matters later in the notes file.

## Stage 3: Your second round

Start when Zach says his first round is done. Do a full, independent review, then critique his comments.

**Your review** covers every file not marked viewed, judged from the whole PR. It follows "What to look for" below and goes beyond it: design, naming, simpler alternatives, missing cases, unclear code, anything else worth a comment.

Review tests in full. Zach often skims or skips them given how much test code PRs carry, so this round is where they get a real review: judge them against the testing rules in Zach's personal rules and the repo's rules files, and report missing coverage for changed behavior.

For large PRs, split the files across subagents; each returns findings with `file:line` and the code excerpt it relied on, not just a summary.

**Zach's pending comments:** Octo saves them in a pending review on GitHub, visible only to Zach until he submits. Read them with:

```sh
gh api graphql -F owner='{owner}' -F repo='{repo}' -F number=<number> -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviews(states: PENDING, first: 5) {
        nodes { body comments(first: 100) { nodes { path line originalLine body diffHunk } } }
      }
    }
  }
}'
```

For each comment, say whether it's right, whether it goes far enough, and whether its wording would land with the author. Then list what neither of you has commented on yet.

Present your findings grouped by file, most serious first, each marked as agreeing with, extending, or new relative to Zach's comments. Write them to the notes file.

## Stage 4: Discussion

Go through both reviews with Zach. For each finding, he decides: comment, drop, or defer. Record each decision and its reason in the notes file.

When drafting a comment for him to post, follow the `writing-style` skill's rules for code review comments. Give him the text; he adds it in Octo.

## Stage 5: Post-review summary

Before Zach submits, give him:

- issues raised in the review that have no comment, and whether that was a decision;
- open questions still unanswered;
- files still unviewed (rerun `pr-context` for current viewed state) that weren't deliberately skipped;
- work decisions made during this review, and rule candidates (handled through `instruction-upkeep`). Zach decides what to record and where.

Add the summary to the notes file.

## What to look for

Follow the `reviewing-code` skill for the review process, the areas to cover, severity, and how to write up findings. On top of that, for every PR:

- `pr-context` lists each changed file's existing tests, changed or not; use them when judging coverage.
- Compare the PR against the ticket fetched in stage 1.

## Extra context

Fetch more only when a question needs it, not by default:

- **Docs:** search the repo's `docs/` (or ADRs) for the feature by name.
- **Full files:** `git show <head>:<path>` when the diff alone can't settle a question.
- **Upstream and downstream code:** callers of a changed function or interface, and what changed code now calls. Worth it for shared pieces like context providers, hooks, and endpoint internals; usually noise for code that's just used as-is.
- **Related PRs:** the `(#123)` suffixes in each file's recent commits from `pr-context`; `gh pr view <n>` for one that looks relevant.

Record what each investigation found in the notes file's `## Investigations` section.
