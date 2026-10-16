---
name: instruction-upkeep
description: "Capture and maintain how Claude should work with Zach: decide where a preference, lesson, or convention belongs (global or work CLAUDE.md, personal rules, a skill, a memory, or rarely a setting or hook), check it against what already exists for duplicates and conflicts, and write it so a reader without the conversation can act on it. Use when Zach likes or dislikes something Claude did, in this session or elsewhere; when Zach states a lasting preference; when you notice a pattern or correction worth capturing as you work (suggest it, don't wait to be asked); or for a cleanup pass over instruction files. Can recommend edits to existing skills or a new skill; it is not for writing new skills."
user-invocable: true
---

# Instruction upkeep

The instructions that shape how Claude works with Zach are spread across CLAUDE.md files, rules, skills, memories, and settings. This skill keeps them accurate, in the right place, and free of duplicates and conflicts.

Always ask Zach before changing any file, whatever its type: propose the exact change and where it goes, and wait for approval.

## When to use it

- Zach likes or dislikes something Claude did, in this session or one he saw elsewhere.
- Zach states a preference or convention that should outlast the session.
- Claude notices a pattern worth capturing: a correction that keeps recurring, or an approach that worked well. Suggest it in a line or two; don't wait to be asked. If it would derail the current work, offer it at the next natural break.
- A cleanup pass over the instruction files.

## Where it belongs

Choose the narrowest home that reliably reaches the moments the guidance is needed. Always-loaded files cost attention in every session, so every line there must be true and useful everywhere it loads.

**First, check whether something already covers it.** If it does and it still didn't work, find out why before changing anything. Common causes: the wording was vague or missing its reason; it lived somewhere that doesn't load at that moment (a path-scoped rule, a memory nobody reads, the wrong config); it was crowded out by too much always-loaded text, such as dozens of skill descriptions; another instruction contradicted it (Claude Code's system prompt, a team rule, another memory); or it was too abstract to beat a strong habit from training data and needed a concrete example. Fix the actual cause - sometimes that's the text, often it isn't.

Otherwise, in order of preference:

1. **Global CLAUDE.md** - `~/src/dotfiles/ai/.claude/CLAUDE.md` (stowed to `~/.claude/CLAUDE.md`). How Zach and Claude work together, in every project. Always loaded in personal and work sessions.
2. **Work CLAUDE.md** - `~/src/work/.claude/CLAUDE.md` (not in dotfiles; backed up by `mksecret`). Work-specific workflow and tooling. Loaded only in work sessions.
3. **A repo's CLAUDE.md, a nested CLAUDE.md, or repo docs** - knowledge specific to one repo or one part of it, including gotchas worth sharing. A nested CLAUDE.md in a subdirectory (e.g. `apps/<app>/CLAUDE.md`) loads when Claude works in that directory; `docs/` suits anything people should read too. In work repos these are committed and team-owned, so changes go through a PR.
4. **Personal rules** - `~/src/dotfiles/ai/.claude/rules/` (`all.md`, `typescript.md`, `golang.md`). Coding preferences. Loaded in personal and work sessions; the language files load only when matching files are touched.
5. **Platform's committed rules** - `~/src/work/platform/.claude/rules/`. Team-owned; changes go through a PR.
6. **A skill** - `~/src/dotfiles/ai/.config/skillz/` (`core/` is listed in every session, `custom/` loads on demand). Guidance needed only for a certain kind of task. Recommend edits to existing skills, or a new skill when one is warranted; Zach decides if and when it gets written.
7. **A memory** - a fact or lesson that's personal or environment-specific and that nothing above fits, such as how Zach reaches a lower-environment database. Not for general preferences. Memories live per project under `~/.claude/projects/<project>/memory/` (personal) or `~/src/work/.claude/projects/<project>/memory/` (work); a project's first memory creates a folder that `mksecret` won't back up until it's added with `mksecret add <folder>`.
8. **A setting or hook** - last resort, only when the behavior must be enforced or configured and no instruction can do it (e.g. turning off commit attribution). Almost always, something above is the better choice.

**Personal and platform rules are kept aligned.** Aligned means that where both cover the same topic, they point the same way and never contradict each other, since both load in work sessions and conflicting rules get followed unpredictably. It doesn't mean identical: personal rules can be broader, and platform's can hold repo-specific conventions. When editing either, check the other for a shared topic that has drifted apart.

## Before proposing a change

1. **Search for the topic everywhere instructions live.** Use `rg` for content and `fd` for files. Zach's `rg` config prefixes every match with `file:line:col`, so add `--no-filename --no-line-number --no-column` when piping its output into another command. Search:
   - `~/src/dotfiles/ai/.claude/` (global CLAUDE.md, personal rules)
   - `~/src/work/.claude/CLAUDE.md`
   - the current repo's CLAUDE.md files, nested ones included, and its `.claude/rules/`; for work, also `~/src/work/platform/.claude/rules/`
   - the memory folders for the current project, under both configs
   - `~/src/dotfiles/ai/.config/skillz/`

   Look for duplicates (merge into one place) and contradictions (resolve before adding anything).
2. **Check it against Claude Code itself.** Claude Code's system prompt is in context: if it already says this, don't repeat it; if it says the opposite, the new instruction has to name the conflict and say which wins and why, because both will be in context. For how Claude Code features behave (what loads when, settings keys, skill visibility, hooks), check the current docs rather than memory, since they change often:
   - `https://code.claude.com/docs/llms.txt` - index of every page
   - `https://code.claude.com/docs/en/memory.md` - CLAUDE.md, rules, imports, symlinks, load order
   - `https://code.claude.com/docs/en/skills.md` - skills, `skillOverrides`, bundled skills
   - `https://code.claude.com/docs/en/settings.md` and `https://code.claude.com/docs/en/settings-reference.md` - settings keys
   - `https://code.claude.com/docs/en/hooks.md` - hooks

   Fetch the raw `.md` pages (e.g. with `curl`) and read the relevant section; summarized fetches have gotten details wrong.
3. **Check that it will load where it's needed:** personal vs. work config, a path-scoped rule's globs, `core/` vs. `custom/` for a skill, and whether a memory's folder is backed up.
4. **For a personal or platform rule, check the other set for alignment** (see above).

## Writing it

- **Claude's own words, not Zach's chat wording.** His phrasing in chat is loose and full of conversation context; copying it is how chat-specific text leaks into instructions.
- **Readable cold.** No references to the conversation, the incident, "as discussed," or alternatives considered. The exception is a memory's **Why:** line, where the triggering incident is the point.
- **Include the reason.** An instruction with its why is followed more reliably and applies better to cases it doesn't name.
- **Concrete where Claude predictably drifts** (a named anti-pattern, a short example); a brief principle elsewhere. Don't try to enumerate everything.
- **Define terms** a cold reader wouldn't know, and say where code-derived terms come from.
- **Keep always-loaded text short.** Sharpening one line beats adding a paragraph.
- **Match the target file's format:** its wrapping, bullet style, and headings. Skills use one line per paragraph with no hard wrapping. Memories use the memory frontmatter, a **Why:** and **How to apply:** body, and a one-line entry in that project's `MEMORY.md`.

## Workflow

1. Run the checks above.
2. Propose: what to capture, where it goes and why there, the exact text, and anything it replaces, conflicts with, or makes redundant.
3. Wait for Zach's approval; discussion may change the proposal.
4. Write it. For team-owned files, that means a branch and a PR.
5. Clean up what it superseded: delete redundant memories and their index lines, and remove duplicated text elsewhere. New memory folders are rare, but when one appears, run `mksecret add <folder>` so it's backed up.
6. Say how to tell whether it worked. An instruction's effect only shows in later sessions, so name the behavior to watch for.
