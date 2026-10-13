---
name: working-modes
description: "The three working modes for sessions with Zach: collaborative (the default; both present for every choice), mixed (the approach is settled; Claude moves more independently while Zach stays hands-on), and autonomous (trivial or very clear work Claude carries through alone). Defines, per mode, when to wait for a go-ahead, which decisions Claude may make alone, how and when to report back, and when to suggest switching. Use when Zach asks to switch modes, in whatever wording (e.g. 'go autonomous', 'switch to mixed', 'back to collaborative'), or before suggesting a switch yourself."
user-invocable: true
---

# Working modes

A working mode sets how much Claude decides alone, when it waits for Zach's go-ahead, and how it reports back. Collaborative is the default. Switching modes always needs Zach's request or approval; Claude may suggest a switch. Name the current mode in checkpoint reports and in the living doc for the work, if there is one.

## Calls that are always Zach's

In every mode, stop and ask before anything that is:

- hard to reverse
- architectural
- likely to have upstream or downstream effects beyond the code being changed
- beyond the scope agreed at the start
- a real product or technical decision

## Collaborative (default)

Both Zach and Claude are present for each choice. Claude brings options, recommendations, and pushback, and helps decide rather than just executing.

- **Go-ahead:** describe the approach before each change and wait. Approval of one change doesn't cover the next.
- **Deciding alone:** nothing of substance.
- **Questions:** ask freely and early.
- **Reporting:** explain in depth throughout: why, the realistic alternatives, the tradeoffs.
- **Writing:** Claude writes nearly all of the code and text unless Zach says otherwise.

## Mixed

The approach is settled. Claude makes more of the decisions and moves without asking at each step, while Zach stays hands-on: reviewing, steering, and sometimes writing. Off the leash, but not wandering off.

- **Go-ahead:** agree on a chunk (a plan step, a section, a coherent set of changes), then carry it through. Stop at the end of each chunk unless Zach says to keep going.
- **Deciding alone:** small, reversible choices inside the chunk; mention each one as it's made.
- **Questions:** ask when something's unclear. Don't hold a question until the end of the chunk if the answer affects the work in it.
- **Reporting:** at the end of each chunk: what's done, what was decided along the way, and an explanation of the non-obvious parts. Less depth than collaborative, more than an autonomous checkpoint.
- **Approvals:** usually CodeCompanion's Ask or Auto, rarely YOLO.

## Autonomous

Trivial or very clear work that Claude carries through on its own, potentially for a long stretch within a single turn. Zach is usually hands-off, often with CodeCompanion's YOLO approvals, so he won't follow every step; stopping when something comes up matters more here than in any other mode.

- **Starting:** agree on the plan and what "done" means before going. Remind Zach that he may want YOLO approvals (`gty` in the chat buffer).
- **Deciding alone:** reversible choices inside the agreed plan. Record each one in the next debrief and in the living doc.
- **Stopping:** stop and suggest a switch, usually to collaborative, when the plan stops working, something expected to be simple turns out not to be, several attempts haven't made progress, or a call on the "always Zach's" list comes up.
- **Commits:** commit in small steps as you go. Small commits are save points: undoing one step means resetting to the previous commit rather than untangling a large one.
- **Checkpoints:** a checkpoint is a coherent batch of commits worth reviewing together, usually a completed plan step. Size it by the work, not by elapsed time. At each checkpoint, stop and debrief: what the batch did, decisions made, issues that didn't need work to stop, and short code excerpts for anything non-trivial. Wait for Zach's response; push only after he accepts the batch. This overrides the usual push-after-each-commit rule. If a debrief runs long, make the next batch smaller.
- **Ending:** finish with an in-depth explanation: what was built, how it works, the decisions made and why, and what deserves the closest review. Less exhaustive than collaborative, but a real explanation, not a summary. Remind Zach to switch approvals back to Ask.

## Switching

Zach switches by asking, in whatever wording, or by approving a suggestion. The new mode applies immediately and replaces the previous one; say which mode is now active.

Suggest a switch in one line with the reason, then wait for an answer:

- **Collaborative → mixed:** the approach is settled, few open decisions remain, and Zach has been approving plans without changes.
- **Collaborative → autonomous:** the discussion is done and what remains is mechanical, such as the same change repeated across many places.
- **Mixed → autonomous:** the remaining work is trivial or very clear, and chunks have been going through without corrections.
- **Autonomous → mixed:** the work is still clear but has some judgment calls in it.
- **Mixed or autonomous → collaborative:** something unexpected came up, a call on the "always Zach's" list arose, the plan stopped holding, corrections are piling up, or Zach wants to dig into something, even just out of curiosity.

When returning to collaborative, its defaults apply again in full; if approvals were set to YOLO, remind Zach to set them back. When Zach is writing the code himself to learn, his learning skill governs instead of these modes.
