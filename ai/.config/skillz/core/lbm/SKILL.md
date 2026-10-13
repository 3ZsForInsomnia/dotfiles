---
name: lbm
description: "Offload bulk, low-stakes text work to a small local model with the `lbm` shell command, so the input never enters your own context. Reach for it mid-task when a command's output is long and mostly noise and you need its gist, not its exact text: a large build log, a long `git log` range, or a changelog. Also use it to reformat, extract from, or classify a batch of items. Input must fit `$LBM_MAX_CHARS` (about 24k characters, a few hundred lines); it refuses anything larger. Covers feeding input, trust, and what never to delegate."
---

# lbm

`lbm "instruction"` sends text to a small model running locally through Ollama and prints only its reply. It is for text you would otherwise have to read yourself: the input goes to the model, and only the short result comes back into your context. The command and its wrappers are defined in `zsh/src/zsh/aliases/ai.zsh`.

## When to use it

It pays off when the input is longer than you'd want in your own context (more than a screen or two of output) and mostly noise, the result you need from it is a gist rather than exact text, and a wrong result is easy to spot. When you need the exact text, such as the error you're about to fix, read it yourself.

- **Long command output where you need the gist.** A test or build run where you want to know what failed and why: `npm test 2>&1 | lbsum "which tests failed, and the error for each"`.
- **Logs.** Summarize them, or pull out the distinct errors or other details: `lbextract "list each distinct error message once" -f app.log`.
- **Change history.** A `git log` range or a dependency's changelog: `git log --oneline v3.0..v4.0 | lbsum "what changed that affects callers"`.
- **Batches of items.** Reformatting (JSON to YAML, rows to a table), pulling fields out of many records, or sorting items into labels you supply.

`lbm` does not replace search. When you need specific lines or files, use `rg`, `fd`, or `tail`; they are instant and exact. Also skip it when the output is short enough to just read.

Input must fit `$LBM_MAX_CHARS` characters: about 24k by default, or a few hundred lines of log. Run `echo $LBM_MAX_CHARS` for the current value.

## The wrappers

Each wrapper puts a fixed base instruction in front of yours, then passes along any piped input and `-f` files. Add your specifics as the argument.

- `lbsum`: summarize. `tail -n 300 build.log | lbsum "focus on the first failure"`
- `lbextract`: extract or reformat data. `lbextract "as a markdown table of name and version" -f deps.json`
- `lbclass`: pick one label from those you supply. `lbclass "into one of: bug, task, story" -f ticket.md`
- `lbm "instruction"`: anything that doesn't fit a wrapper.

## Feeding it input

The value is in input you never read, so how you pass it matters.

- **Pipe it:** `cmd 2>&1 | lbm "..."`. Add `2>&1` when the useful part goes to stderr, as it often does for test runners and compilers.
- **Point at files:** `-f path`, repeatable. Each file is labeled with its path, so the instruction can refer to files by name.
- **Don't paste content into the instruction.** You have already read it, so this saves nothing.

### When it refuses input as too large

Over `$LBM_MAX_CHARS`, `lbm` sends nothing, prints the input size and the limit, and exits 1. Reduce the input; never raise the limit. The limit sits below the point where the model silently drops the start of the input, and input that would need a higher limit is too big for `lbm` anyway.

- **Filter to the part that matters:** `tail -n 300`, `rg -C 5 'ERROR|FAIL'`, or `git log --oneline` instead of the full log.
- **If all of it matters, split it:** `split -l 500 big.log /tmp/chunk.`, then run each chunk and combine the results yourself or with one more `lbm` call.
- **Run chunks one after another.** The local model handles one request at a time, so parallel calls just wait in line.

## How far to trust the output

Treat it as a quick draft from a careless assistant. Small local models are inconsistent, and they often ignore "output only X".

- **Summaries:** good enough to get your bearings, like which tests failed or roughly what changed. Before acting on a specific claim, such as a file name, line number, or error message, check it against the source with `rg`.
- **Extraction and reformatting:** it can drop or invent rows and fields. Spot-check the result, and compare counts when you can (`wc -l` on input and output).
- **Classification:** don't exact-match the reply. Look for which of your labels appears in it; the model may capitalize it, hedge, or add prose around it.

## What not to delegate

Hand off mechanical bulk and keep the judgment. Never delegate:

- **Correctness-critical work:** logic, code that must be right, or anything where a plausible but wrong answer is costly.
- **Security-sensitive work:** auth, secrets, permissions, crypto, input validation.
- **Anything that needs taste or design judgment:** architecture, tradeoffs, naming that matters, wording someone will read and rely on.
- **Anything where checking the output costs as much as doing the work.** If you'd have to read the whole input to verify the result, delegating saved nothing.

## When `lbm` fails

Errors go to stderr, prefixed with `lbm:`, and the exit code is 1.

- **`request to ... failed`:** Ollama isn't running or isn't reachable. Run `lama-restart`, which restarts the Ollama LaunchAgent, then retry once. If it fails again, do the task without `lbm`.
- **`model '...' not found`:** the configured model isn't downloaded. Report it rather than running `ollama pull`; models are many gigabytes, and which model to use is a deliberate choice.
- **`input is N chars, over the LBM_MAX_CHARS limit`:** see "When it refuses input as too large" above.
- **Empty or off-task output,** such as a reply that restates the instruction or ignores the input: rerun once with a more specific instruction. If it's still wrong, do the task yourself or narrow the input with `rg` and read it directly.
