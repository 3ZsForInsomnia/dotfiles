---
name: reviewing-code
description: "How to review a code change: the process to follow, the areas a review must cover, how to grade severity, and how to write up findings. Use whenever reviewing code: someone else's PR, Zach's own branch before it's ready, or any diff Zach asks you to look at."
user-invocable: true
---

# Reviewing code

The coding rules in context (Zach's personal rules and the repo's `CLAUDE.md` and rules files) say how code should be written, including language- and framework-specific practices. A review checks the change against them. This skill adds the process and the areas to cover. Both are a floor: raise anything else worth a comment, including design, naming, simpler alternatives, and unclear code.

## Process

1. **Understand the intent first.** Read the ticket and the description before the code, so you can judge whether the change does what it's meant to and nothing unrelated.
2. **Read in dependency order.** Start with what everything else builds on (schemas, types, interfaces, core logic), then the code that uses it. Read each file's tests right after the file.
3. **Trace the data.** Follow each new or changed value from where it enters (request, event, user input, file) to where it's stored, returned, or displayed. Bugs cluster where data crosses a boundary or changes shape.
4. **Check what callers rely on.** When a function, endpoint, or component keeps its signature but changes behavior, find its callers, including code outside the diff, and check that each still gets what it depends on. The type checker catches changed signatures; it doesn't catch changed meaning.
5. **Verify before reporting.** Read the surrounding code and confirm the problem is real: not handled elsewhere, not ruled out by a type, not intended per the description. Skip anything a linter or formatter catches.

## Areas to cover

- **Correctness:** the change does what it claims, including edge cases, error paths, partial failure, and concurrency.
- **Compatibility:** changes the types don't show: same signature with different behavior, data already stored in the old shape, and consumers across a boundary the compiler doesn't check, such as other services or generated clients.
- **Security:** who can reach the changed code and what they can do with it.
- **Performance:** cost of the change at realistic data sizes and request volumes.
- **Tests:** judged against the testing rules in context; changed behavior has tests that would fail without the change.
- **Intent:** the change matches the ticket, and the title and description explain what changed and why.

## Severity

Grade every finding:

- **Blocking:** a bug, security hole, data loss risk, or broken consumer. Must be fixed before merge.
- **Should fix:** a real problem with lower impact, or a clear rule violation.
- **Suggestion:** an improvement worth considering; the author can reasonably decline.
- **Question:** something unclear that may or may not be a problem.

Label each rule violation with the rules it breaks. One that breaks only Zach's personal rules, not the repo's, is labeled `personal rule`: it's his preference rather than the team's standard, and he decides whether to raise it.

## Writing up a finding

- **Where:** `path:line` or `path:start-end`, up to three ranges; when it spans more, list the files instead.
- **What's wrong,** in one or two sentences.
- **Why it matters:** the concrete consequence: what breaks, for whom, when.
- **The fix,** when it's obvious.
- **The evidence:** the excerpt the finding rests on, or the caller it breaks.

Order findings by severity, most serious first.
