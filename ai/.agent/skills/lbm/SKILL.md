---
name: local-delegation
description: "How and when to offload grunt work to the local model (codestral via Ollama) using the `lbm` shell command, to save Claude's own context and reasoning. Consult before delegating summarization, classification, extraction/reformatting, boilerplate drafting, or first-pass proofreading — and to decide when NOT to delegate. Covers the task wrappers, how to feed input without defeating the purpose, how much to trust the output, and the hard guardrails."
---

# Local Delegation (`lbm`)

`lbm` sends a task to a local model (codestral, via Ollama) and prints only its
response. The point is **saving Claude's context and reasoning**: hand off cheap,
high-volume, low-stakes work instead of spending your own tokens on it. The
command and its task wrappers live in `zsh/.../aliases/ai.zsh`; the prompts are
baked into the wrappers. This skill is the *judgment* layer — what to hand off,
how, and how far to trust the result.

## Feed it input the right way — or you save nothing

The whole value is context you never ingest. So:

- **Best — a file:** `lbm "..." -f path` (repeatable). The model reads it; you
  only ever handle the path.
- **Best — piped output:** `cmd | lbm "..."`. The output flows straight to the
  model; you never see it. `tail -500 run.log | lbsum` — those 500 lines never
  enter your window.
- **Weakest — inline content:** typing the content into the instruction. You
  already read it into context, so this saves only *reasoning*, not context. Fine
  for small things; never the way to handle bulk.

## The wrappers

Each bakes in a stable base prompt; append your specifics and any `-f`/pipe input.

- `lbsum` — summarize (logs, test output, tickets, diffs, notes).
- `lbclass "into one of: A, B, C"` — classify into labels you supply.
- `lbextract "..."` — extract or reformat structured data (JSON↔YAML, tables, fields from markdown/CSV).
- `lbproof` — spelling/grammar pass, wording preserved.
- `lbcommit` — Conventional Commits message from a staged diff (`git diff --staged | lbcommit`).
- `lbpr` — PR description (Summary / Changes / Test plan) from a diff.
- Raw `lbm "instruction"` — anything one-off that doesn't warrant a wrapper.

## Trust the output like a fast, sloppy intern's draft

codestral is competent but **inconsistent** — notably, it does not reliably obey
"output only X." So:

- **Classification:** don't exact-match its reply. Scan the output for which of
  your labels appears; it may capitalize, add prose, or hedge.
- **Extraction/reformatting:** verify the result — it can drop or invent fields.
- **Prose (summaries, PR/commit drafts, proofreading):** treat as a first draft
  to read and fix, never ship unread.
- Its context is ~16k tokens; very large inputs are silently truncated. Chunk, or
  do it yourself.

## Do NOT delegate

Hand off mechanical bulk, keep the judgment. Never delegate:

- **Correctness-critical work** — logic, code that must be right, anything where a
  plausible-but-wrong answer is costly.
- **Security-sensitive work** — auth, secrets, permissions, crypto, input validation.
- **Anything needing taste or architecture** — design decisions, naming that
  matters, tradeoffs, user-facing wording that carries weight.
- **Anything where verifying its output costs as much as doing it yourself.** If
  you'd have to read the whole input to check the result, delegating bought you
  nothing.
