---
created: {{DATE}}
modified: {{DATE}}
type: meta
status: active
---

# PR review agent

A GitHub Action (`.github/workflows/pr-review.yml`) that reviews every PR against this repo's own rules, proposes fixes and commits them only after you approve. It runs in GitHub's cloud, so the Mac can be off. It covers the weekly digest PRs too.

## How it works

| You do | Agent does |
|---|---|
| Open a PR (or mark a draft ready) | Reads `CLAUDE.md`, `learning.md`, any governing `_meta/` spec and the diff, then posts **one comment**: ✅ ready, or ⚠️ up to 5 numbered fixes (`path:line`: defect → fix). GitHub emails it to you. |
| `/approve` | Applies every item not marked `(needs you)`, runs repo checks, commits, pushes to **the PR's own branch** and replies with the commit. |
| `/approve 1,3` | Same, for those items only. Naming a `(needs you)` item explicitly applies it. |
| `/reject` | Acknowledges. No changes. |
| `/review` | Re-runs the review (use it after you push changes). |

You still merge. The agent never merges and never pushes to `main`/`master`.

## Guardrails

- Commands only count from the repo owner (`github.repository_owner`), and the checks are in the workflow's `if:` conditions, not just the prompt.
- Same-repo PRs only. Fork PRs are refused, so secrets never reach them.
- Instructions (`.github/pr-review/*.md`) are read from the **base** branch, so a PR can't rewrite its own reviewer.
- Propose has read-only tools plus `gh pr comment`. Apply can edit and commit, but can't push, comment, reset, rebase or check out. The workflow pushes, after refusing if the head branch is `main`/`master` or the commit touches `.github/`.
- Pushes use `GITHUB_TOKEN`, which doesn't re-trigger workflows, so there are no loops.
- §7 privacy findings are always `(needs you)`: the agent shows you what's identifying instead of silently scrubbing it.

## Setup

1. Create a token: run `claude setup-token` (this uses your Claude subscription), then `gh secret set CLAUDE_CODE_OAUTH_TOKEN -R <owner>/<repo>`.
2. Merge the PR that adds the workflow. Comment commands (`issue_comment` events) only run from the default branch.

Without the secret, every run skips with a notice.

## Tuning and turning off

- Change what it checks: edit `.github/pr-review/propose.md` (review) or `apply.md` (fixes) in a PR.
- Model: `MODEL` in the workflow (`claude-sonnet-5-5`).
- Pause it: Actions → PR review agent → ⋯ → Disable workflow. Remove it: delete the secret.
