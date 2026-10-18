# All Code

## Philosophy

- Functional style by default, at a practical level: pure functions with descriptive names, data transformations, immutable values, and composition of small functions. No category-theory machinery (monads, functors). Reach for classes, OOP, or local mutation only when the domain or a framework genuinely calls for it.
- Prefer several small named functions that a top-level function calls in sequence over one long function doing the same work inline; the caller should read as a list of named steps. Anonymous functions are fine when they're small.
- When two functions are similar, extract the shared steps into named helpers that both call.
- Explicit over implicit.
- Code should read like English. Use descriptive names, named conditions, and named helper functions. Extract multi-part conditionals into named booleans - a reader should understand intent without mentally evaluating subexpressions. Derive a condition once and reuse the boolean rather than restating its clauses.
- Keep trivial conditionals inline. For non-trivial branching, prefer strategy selection - pass in the input, get back the right handler - or delegate each branch to a named function, over growing `if`/`switch` chains.
- Prefer declarative code over stateful and imperative code.
- Functions under 20 lines; max 3 levels of nesting; use early returns to reduce nesting.
- Reuse existing code. Check what exists in the project before writing something new.
- Write code that's easy to delete. New functionality should be isolated enough to remove without cascading changes.
- Prefer well-known design patterns when they fit - dependency injection for testability, strategy for varying behavior. Don't force patterns where they don't belong.
- Use idiomatic patterns and current best practices for the language or framework. Prefer current, well-maintained libraries; avoid deprecated APIs and patterns.
- Leave the code you touch better than you found it: small refactors, cleanup, accurate comments, and doc updates where they apply. Keep it to the files and areas the change already touches and in proportion to the change, and call out what you cleaned up so it's reviewable. This isn't license to go hunting across the codebase. Err toward a little cleanup; occasionally, such as under real time pressure, it isn't an option. Cleanup can leave CI lint red on pre-existing issues the change exposed - that's acceptable; don't suppress them just to go green.

## Types

Prefer narrow, specific types. Types should encode what is actually possible at a given point in the program - avoid optionality and union with null/undefined/nil when the data is known to exist. Make invalid states unrepresentable. Be strict, but stop short of type gymnastics that make code hard to read or change.

## Values and Errors

- Validate all external inputs at system boundaries. Everything past the entry point can be trusted.
- Fail loudly as early as possible when required data is missing. The first function that needs a value should throw, not pass the absence deeper.
- Don't swallow errors silently - rethrow, surface to the user, or log. Silence is never acceptable.
- Use structured logging. Never include sensitive data, PII, or secrets in log output.

## Code Style

- Extract values to named constants when they are non-obvious or appear more than once. A bare `7` with no context is a magic number; `0` in an array index is not.
- Lint and type suppressions (`eslint-disable`, `@ts-expect-error`, `nolint`, etc.) are a last resort: use one only when it's genuinely the only sane way forward, with a comment explaining why. When an issue has many instances, fix some of them in the files you're touching before suppressing the rest - but don't try to fix them all.
- Keep new files under ~250 lines. When an existing file grows long, extract a cohesive piece into a new file rather than letting it sprawl.
- Use vertical whitespace: a blank line between logically distinct groups of statements, after a block of declarations, and before a `return`. Don't cram statements together.
- Don't fix or flag issues a formatter or linter autofixes - tooling handles it.

## Comments and PR descriptions

Comments are welcome where they add durable value. The bar is not quantity - it's that a comment must make sense to a reader who has none of our conversation and no task context.

- No chat-specific content anywhere in what you write: code itself (names, strings, log and error messages), comments, commit messages, and PR descriptions. Don't reference what we discussed, alternatives we considered but didn't take, or "the requirements were X," and don't carry over my chat wording. A ticket reference is fine when it genuinely helps a future reader.
- Comments describe the code as it is now and why. No changelog notes - "this used to do X," "changed in PR #123," "updated after JIRA-456" - the diff and history already hold that. Don't note what the code doesn't do or handle unless a reader would reasonably expect it to; otherwise the mention just confuses. Either is fine in the rare case where it records something a future reader genuinely needs.
- Don't comment code that already reads clearly.

The no-chat-content rule applies to PR descriptions too. The "as it is now" rule doesn't: a PR describes a change. When a real, non-trivial refactor is a significant part of the PR, explain the old shape and why it changed; skip that for small incidental refactors. Docs default to how things work now; record what used to be true only when a reader needs it, such as a migration guide or a behavior change readers will run into.

## Testing

- Test from the user's perspective. Don't assert on internal state, props, or implementation details.
- Tests may import production types, enums, and constants - reusing them keeps tests strongly typed. The dependency runs one way: production code never imports from test files, test helpers, or mocks.
- Never skip, delete, or comment out tests to make a suite pass.
- Never modify assertions to match wrong output.
- Never weaken mocks or broaden test setup to fix a failing test without understanding the failure.
- Extract reusable test helpers - setup, fixtures, mock factories, assertion helpers - as soon as a second test would benefit. Bias toward extraction, not speculation.
- Write coverage as you write code. Don't run coverage tooling retroactively to chase a number.

## Git and PRs

- Use Conventional Commits when committing: `type(scope): description`. Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
- PR descriptions must be complete. Delete sections that don't apply rather than writing "N/A".
- Never use `git checkout` to undo changes.
- Default to one PR per feature or task, including any new components or helpers it needs. Split only for a real reason - a different reviewer, separate deploy risk, a size I flagged - and say what it is. An ordering between parts isn't one; nothing is used until it merges.
- After committing on a feature branch, push in the same step. Pushing to the default branch is fine without asking in my personal repos (notes, dotfiles); in other repos, ask first. Never force-push without asking, and ask before pushes that trigger deploys or other workflows.
- Batch fixes for a round of review feedback into one push; multiple commits in it are fine.
- In PR comments and review replies, describe what changed rather than citing commit SHAs - they go stale after a rebase or squash.
