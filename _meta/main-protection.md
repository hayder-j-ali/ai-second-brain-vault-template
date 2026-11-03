---
created: {{DATE}}
modified: {{DATE}}
type: meta
status: active
---

# Main protection

The rule: **`main` only changes by merging a reviewed PR.** Claude never pushes to `main` and never merges (CLAUDE.md §5.7).

GitHub's own branch protection and rulesets are free for **public** repos, but need a paid plan for **private** ones, and your vault should be private. This template covers the gap with three free layers:

| # | Layer | Where | Covers | Effect |
|---|---|---|---|---|
| 1 | Claude Code hook `claude/hooks/block-push-main.sh` | Your machine, installed into `~/.claude` | Claude sessions: `git push` to main/master, `gh pr merge`, `gh repo create --push` | **Blocks** |
| 2 | Git hook `.githooks/pre-push` | Each clone | Every tool on the machine: terminal, IDE, git GUIs, Claude | **Blocks** |
| 3 | GitHub Action `.github/workflows/guard-main.yml` | GitHub | Everything, including the cloud digest routine, other machines and web-UI edits | **Detects**: opens an issue (GitHub emails you) and fails the run |

If you have a paid plan, add a ruleset requiring a PR for `main` and keep layer 3 as a backstop.

## Setup

`scripts/setup.sh` does layer 2, and does layer 1 if you pass `--install-claude-hook`. To do it by hand:

```sh
git config core.hooksPath .githooks          # layer 2, once per clone
```

For layer 1, copy `claude/hooks/block-push-main.sh` to `~/.claude/hooks/` and add the `PreToolUse` entry from `claude/settings-snippet.json` to `~/.claude/settings.json`. Run `tests/test-block-push-main.sh` to check it (29 cases).

**Override, for humans only, never an agent:** `ALLOW_PUSH_MAIN=1 git push …` passes layer 2. `git push --no-verify` also skips git hooks, which is why layer 3 exists.

## When layer 3 fires

You get an issue titled "⚠️ Unreviewed change on main: …" with the commit, the previous `main` SHA and the actor.
- **Legitimate** (e.g. a deliberate web-UI edit): close the issue.
- **Not legitimate:** run `git revert <sha>` on a branch, then open a PR and merge it. For a force push, push the "previous main" SHA from the issue to a branch and PR it back.

The check passes when the new head of `main` belongs to a PR merged into `main`. Merge, squash and rebase merges all count. **Manual test:** Actions → Guard main → Run workflow, giving it the SHA of a commit that was pushed directly, such as the repo's very first commit.
