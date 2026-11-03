---
created: {{DATE}}
modified: {{DATE}}
type: meta
status: active
---

# Digest routine setup

The weekly digest runs as a **Claude Code cloud routine**, a scheduled agent in Anthropic's cloud. Each run gets a fresh clone of your GitHub repo, so **your computer can be off**. It writes one digest and opens a PR, and you merge it.

> Why not a local scheduled task? A job that needs your machine skips or delays a run whenever the laptop is asleep or offline. A cloud routine doesn't.

## Requirements

- A Claude plan with Claude Code cloud routines.
- The vault pushed to a **private** GitHub repo, with Claude's GitHub access able to see it. Grant it the first time you use Claude Code on the web or create a routine.
- `_meta/digest-spec.md`, with its ⚙️ configuration section filled in, **merged to `main`**. The run reads it from there.

## Create the routine

**Option A: from Claude Code (recommended).** Open Claude Code in your vault and say:

> Create a weekly cloud routine from `routine/digest-prompt.md`. Repo: `<your-repo-url>`. Schedule: Sundays 13:00 `<your-timezone>`. Model: Sonnet. Tools: Bash, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch. No MCP connectors.

Claude uses its `/schedule` skill and shows you the config before creating it.

**Option B: by hand.** Go to claude.ai/code/routines and create a new routine:
- **repository:** your vault
- **prompt:** the part of `routine/digest-prompt.md` below the line, with the placeholders filled in
- **schedule:** for example, cron `CRON_TZ=Europe/London 0 13 * * 0`
- **tools:** the list from Option A

**Recommended settings:**
- **Tools:** `Bash, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch`. An unattended run can't answer permission prompts, so only pre-allowed tools will work.
- **No MCP connectors.** The run needs only web search and git. Fewer tools also means a smaller blast radius.
- **Model:** Sonnet is plenty.

## Test it

Run the routine once by hand ("run now"). Within a few minutes you should see a branch called `claude/digest-<today>` and a PR containing only `digests/digest-<today>.md`. Check that `main` is untouched. You can close or merge the test PR.

## Maintenance

- **To change what the digest does,** edit `_meta/digest-spec.md` in a PR. There's no need to touch the routine.
- **To change the mechanics** (schedule, branch naming, allowed files, PR shape), edit the routine's prompt, and keep `routine/digest-prompt.md` in sync.
- **To debug,** ask Claude Code to show the routine's recent runs and the log of the one that misbehaved.
- **If a digest PR is missing,** check the run log first. The usual culprits are repo access or a tool that isn't on the allowed list.

## Safety

The prompt forbids pushing to `main` and merging. In the cloud, that's backed only by the prompt plus the `guard-main` GitHub Action, which flags any unreviewed change on `main`. See `_meta/main-protection.md`.
