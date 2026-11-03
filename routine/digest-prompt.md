# Weekly digest: cloud routine prompt

Paste everything **below the line** into the routine's prompt. Before you do, replace the three `{{…}}` values. See `_meta/digest-routine-setup.md` for how to create the routine.

The prompt is deliberately thin. It covers only the cloud and git mechanics. *What* the digest does lives in `_meta/digest-spec.md`, which the run reads from `main` every week, so you can tune the digest by editing the spec in a PR without touching the routine.

---

You are running unattended in Anthropic's cloud as a scheduled weekly job. Nobody will answer questions: make reasonable calls and finish. The vault is the git repository checked out in your working directory ({{GITHUB_REPO_URL}}, a private Obsidian "second brain" for {{ONE-LINE DESCRIPTION OF THE OWNER}}). Every path below is relative to the repo root.

## Setup (do this first)
1. DATE=$(TZ={{TIMEZONE}} date +%F). That is today's date for the filename, branch and PR.
2. `git checkout main && git pull`. If `digests/digest-$DATE.md` already exists on main, or a remote branch `claude/digest-$DATE` already exists, stop and report "digest for $DATE already exists". Don't overwrite anything.
3. Create and switch to branch `claude/digest-$DATE`.
4. Some earlier digests may still be in unmerged PRs. Run `git fetch origin '+refs/heads/claude/digest-*:refs/remotes/origin/claude/digest-*'`. When you pick "the last 3 digests", include digest files that exist only on those branches (`git show origin/claude/digest-X:digests/digest-X.md`), and pick the 3 most recent by date across main and those branches.

## The task: follow the spec
Read `_meta/digest-spec.md` in full **before doing anything else**, and follow it exactly. It is the single source of truth for this digest: your configuration, Step 0, the belief-change and worth-your-time tests, source rules, the ledger with escalation and proposed defers, the output template, the word budgets and the writer rules. It overrides your own habits about what a digest looks like. If anything in this prompt seems to conflict with the spec, the spec wins, except for the git rules below.

Also read `CLAUDE.md` §1 (what the vault is for) and the last 3 digests in full, so you match their vault connections without copying their length.

Search the web for the past 7 days, or since the most recent digest if that was sooner. Every tiered item and the ⭐ need real, dated, traceable URLs.

## Git rules (hard)
- NEVER push to main. NEVER merge a PR. The user reviews and merges every digest.
- Files you may change: `digests/digest-$DATE.md` (new), plus append-only `defer` entries at the end of `log.md` when the spec's proposed-defer rule fires. Nothing else. Never edit existing lines in `log.md`.
- When done:
  - Commit on `claude/digest-$DATE` with the message "Digest $DATE".
  - Push that branch.
  - Open a pull request into main, titled "Digest $DATE". The PR body has the ⭐ action and its "why it's worth your time" line. If any proposed defers were added to `log.md`, list them under "Proposed defers (merge to accept, delete the log.md entry to reject)". Keep the body under 150 words.
  - Use `gh pr create --base main`, or whatever PR-creation tool this environment provides. If nothing works, leave the branch pushed and say so.
- End with a short final message: the PR link, the ⭐ action, the number of proposed defers, and the scan section's word count.
