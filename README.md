# Second Brain Vault Template

A ready-to-clone **Obsidian + Claude Code "second brain"** for building real expertise, rather than a pile of notes. Claude maintains a compounding wiki for you: you bring sources and judgment, and Claude does the bookkeeping. A weekly cloud agent scouts your field and hands you **one** worthwhile thing to learn, as a pull request you review.

It's built on the LLM Wiki pattern (a persistent synthesis an LLM maintains on your behalf), plus three things that make it hold up over months:

- **A schema Claude follows** (`CLAUDE.md`): three strict layers (raw sources → wiki → schema), typed pages with frontmatter, an ingest loop where Claude discusses takeaways *before* writing, a "challenge me" clause, privacy rules for work content, and a self-improving `learning.md`.
- **A weekly digest that runs in the cloud** (`_meta/digest-spec.md`): it reads your vault first, tiers new developments by whether they'd change what you believe, keeps a ledger of open decisions, gives exactly one ⭐ action that must pass a "worth your time" test, and pre-drafts an ingest kit. It runs while your laptop is off and arrives as a PR.
- **PR-only discipline**, so nothing lands on `main` without your review, even from agents. There are three free layers: a Claude Code hook, a git `pre-push` hook, and a GitHub Action that flags unreviewed changes. That matters because GitHub's branch protection isn't free for private repos.

```
 you ──drop source──▶ inbox/ ──ingest (discuss → approve → write)──▶ wiki pages ──PR──▶ you merge
                                     ▲
 cloud routine (weekly) ──digest PR──┘  ⭐ one action + 🧰 ingest kit + 🕓 open decisions
```

## Quickstart

1. **Create your own private copy:** click **Use this template** → **Create a new repository** → choose **Private**. Your vault will hold personal and work notes, so keep it private.
2. **Clone it and run setup:**
   ```sh
   git clone https://github.com/<you>/<your-vault>.git && cd <your-vault>
   scripts/setup.sh --install-claude-hook   # or just scripts/setup.sh to skip the ~/.claude hook
   ```
3. **Make it yours.** Open Claude Code in the folder and say:
   > Read CLAUDE.md. Interview me to fill in every `{{placeholder}}` in CLAUDE.md §1 and the ⚙️ section of `_meta/digest-spec.md`, then open a PR.

   For a filled-in reference, see `examples/analytics-engineering/`.
4. **Merge that PR on GitHub.**
5. **Set up the weekly digest:** follow `_meta/digest-routine-setup.md`. It takes about 5 minutes, and Claude can create the routine for you.
6. **Use it:**
   - Drop articles into `inbox/` (Obsidian Web Clipper works well) and say *"ingest the new source"*.
   - Ask questions against the wiki.
   - Run *"lint the wiki"* now and then.
   - Each session ends with a PR for you to review.

## What's in the box

| Path | What it is |
|---|---|
| `CLAUDE.md` | The vault schema: purpose, architecture, page types, operations, privacy, git workflow |
| `AGENTS.md` | A pointer so other agents (e.g. Codex) follow the same schema without duplicating it |
| `index.md`, `log.md`, `learning.md` | Catalog, append-only log, and capped rules-from-experience |
| `templates/` | Page templates: pattern, position, case, domain, source |
| `_meta/digest-spec.md` | The digest spec, and the single source of truth for what the digest does |
| `routine/digest-prompt.md` | The thin cloud-routine prompt (mechanics only) |
| `_meta/digest-routine-setup.md` | How to create, test and debug the routine |
| `_meta/main-protection.md` | The three main-protection layers explained |
| `.githooks/pre-push` | Blocks pushes to main/master from any local tool |
| `.github/workflows/guard-main.yml` | Opens an issue if `main` changes without a merged PR |
| `.github/workflows/pr-review.yml`, `.github/pr-review/` | Optional PR review agent: proposes fixes, commits them on `/approve` |
| `_meta/pr-review-agent.md` | How the PR review agent works and how to switch it on |
| `claude/` | Claude Code hook + settings snippet (layer 1) |
| `tests/test-block-push-main.sh` | 29-case regression test for the Claude hook |
| `scripts/setup.sh` | One-time setup |
| `examples/analytics-engineering/` | A filled-in configuration to learn from |

## Design choices worth knowing

- **Discuss before writing.** Every ingest starts with Claude summarizing the takeaways, and nothing is filed until you approve, which keeps the wiki yours.
- **The digest is a menu, not a source.** It never ingests or edits wiki pages. Its only write outside `digests/` is an append-only *proposed* deferral, which takes effect only if you merge it.
- **Conversion is the scorecard.** A digest is only useful if its picks become ingests. Hence the single ⭐, the worth-your-time test, the ingest kit, and the ledger that forces a decision, followed by a proposed deferral at 6 weeks.
- **The spec is the single source of truth.** The routine prompt only handles git and the cloud, so you tune the digest by editing one markdown file in a PR.
- **Privacy is a hard rule.** Case studies are anonymized with a cooling period, and Claude refuses identifying input rather than silently scrubbing it.

## Optional: PR review agent

Every PR, including the weekly digest, can get a short review against your `CLAUDE.md`, with up to 5 numbered fixes. Reply `/approve`, `/approve 1,3` or `/reject` on the PR, and the agent commits the approved fixes to that PR's branch. You still merge. To switch it on, run `claude setup-token` and then `gh secret set CLAUDE_CODE_OAUTH_TOKEN`. Without the secret it skips quietly. See `_meta/pr-review-agent.md`.

## Requirements

- [Claude Code](https://claude.com/claude-code). Cloud routines need a plan that includes them.
- `git`, `gh` (GitHub CLI) and `jq`.
- Optionally [Obsidian](https://obsidian.md) for reading.

## License

MIT. See `LICENSE`.
