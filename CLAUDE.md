# CLAUDE.md — Vault Schema

This file is the operating manual for any Claude session working in this vault. Read it first, every time. If something here is unclear or contradicted by reality, flag it. This file co-evolves with the work.

> **First-time setup:** replace every `{{PLACEHOLDER}}` in this file (search for `{{`). §1 is the only part that really needs your own words. The rest works as-is and can be tuned later. For a filled-in example, see `examples/analytics-engineering/`.

**The live copy of this file in the vault is the single source of truth.** Chat sessions work from copies, and copies go stale. Edit this file in Claude Code, which writes the real file. Don't paste it in from a chat sandbox.

**Session boot order:** read `CLAUDE.md`, then `index.md`, then `learning.md` before doing any work. `learning.md` carries short, evolving rules derived from prior sessions. Treat it as required reading alongside this file (see §9.3).

---

## 1. Purpose

This vault is a **second brain for building defensible expertise as {{YOUR ROLE, e.g. "a product designer", "an employment lawyer", "an analytics engineer"}}**, aimed at {{YOUR GOAL, e.g. "a freelance practice", "promotion to staff level", "writing a book"}}.

It is **not** a generic notes app. It implements the LLM Wiki pattern: a persistent, compounding synthesis that Claude maintains on your behalf. You curate sources and ask questions. Claude does the bookkeeping that makes knowledge accumulate.

**The moat is {{YOUR CORE CRAFT}}**, the transferable skill and judgment you carry to every project. Depth in any single niche is not the moat. **Defensibility comes from three things, in this order:**
1. **Craft depth:** the methods, techniques and judgment of {{YOUR CORE CRAFT}}. This is the centerpiece.
2. **Opinionated positions:** your own frameworks and takes, refined over time. People are hired for judgment, not knowledge.
3. **Receipts:** anonymized case studies from real work that prove the craft works across contexts.

Domain knowledge (industries, verticals, specialist areas) is a first-class but **pluggable** layer. It earns its place when it connects back to a transferable craft lesson.

---

## 2. Three-layer architecture

Strict separation. Never mix.

| Layer | What it is | Who writes it |
|---|---|---|
| **Raw sources** (`raw/`, `inbox/`) | Immutable inputs: articles, PDFs, your work notes, transcripts | You drop them in; Claude only reads them |
| **Wiki** (`craft/`, `domain/`, `positions/`, `cases/`, `index.md`, `log.md`) | Claude-authored synthesis | Claude writes; you read and approve |
| **Schema** (this file, `_meta/`) | Rules and conventions | Co-authored, edited deliberately |

**Hard rule:** Claude never modifies files in `raw/` or `inbox/`. If a source is wrong or needs correcting, Claude flags it and you decide.

**Hard rule:** you generally don't write wiki pages directly. Dictate to Claude in chat and let Claude file it, which keeps the conventions consistent. The exception is `positions/`, where you may draft and Claude refines (see §6).

---

## 3. Folder map

```
vault/
├── CLAUDE.md              ← this file
├── AGENTS.md              ← pointer to this file for non-Claude agents; never duplicate content into it
├── index.md               ← content catalog, organized by section
├── learning.md            ← session-derived rules; capped, evolving (co-read with index.md)
├── log.md                 ← chronological append-only record
│
├── inbox/                 ← sources arrive here; processed within ~7 days
├── digests/               ← weekly digests from the cloud routine, arriving as PRs (menus, NOT sources)
├── templates/             ← page templates (one per page type)
├── archive/               ← genuinely-dead pages only
├── projects/              ← time-bound work (a course, a client gig); operational, not synthesis
│
├── raw/                   ← immutable processed sources
│   ├── articles/
│   ├── pdfs/
│   ├── work-notes/        ← your raw work notes (anonymized per §7 before filing)
│   └── assets/
│
├── craft/                 ← your core craft (THE center of gravity)
│   ├── patterns/          ← reusable approaches
│   ├── tools/             ← specific tools / software / instruments
│   └── concepts/          ← definitions
│
├── domain/                ← pluggable domain knowledge. One subfolder per domain, added only when warranted.
│   └── _cross-domain/     ← spans domains
│
├── positions/             ← your opinions and frameworks (moat layer 2)
├── cases/                 ← anonymized work retros (moat layer 3)
│
├── .githooks/, .github/   ← repo tooling: pre-push guard + guard-main Action (see _meta/main-protection.md)
└── _meta/                 ← schema and conventions
    ├── digest-spec.md     ← spec for the weekly digest (single source of truth)
    ├── digest-routine-setup.md ← how the weekly digest cloud routine is wired
    └── main-protection.md ← how `main` is guarded
```

Folder names are lowercase. Don't pre-create empty domain folders, because that's speculative structure. Add a domain when a real project or sustained interest warrants it. Anything that spans domains goes in `_cross-domain/`.

---

## 4. Page types and frontmatter

Every wiki page has YAML frontmatter. Templates live in `templates/`.

```yaml
---
created: YYYY-MM-DD
modified: YYYY-MM-DD
type: pattern | tool | concept | domain | position | case | source | meta
status: draft | active | stale
confidence: low | med | high
last-reviewed: YYYY-MM-DD
domain: cross-domain | <domain>   # only on domain/case pages
sources:
  - "[[raw/articles/slug]]"
tags: []
---
```

**Page type rules:**
- `pattern`: a reusable approach. Must include when to use it, when not to, and at least one concrete example. Confidence starts `low` until you've actually applied it.
- `tool`: a specific tool. Must include what it's for, the sharp edges you've hit, and alternatives.
- `concept`: a short definition page that links out to the patterns and tools that use it.
- `domain`: domain-specific knowledge. Carries `domain:` and cites specific sources. It should link back to the craft pattern(s) it informs.
- `position`: your opinion or framework. Must say what the claim is, what the evidence is, and what would change your mind. Never `confidence: high` without at least two linked cases or strong external evidence.
- `case`: an anonymized work retro, structured as situation → action → outcome → learning → the positions it supports or contradicts. See §7.
- `source`: a summary of one ingested source, living near the page it informs. It always links back to the raw source.
- `meta`: anything in `_meta/`.

**Status:** `draft` means not yet citable, `active` means current best understanding and citable, and `stale` means it needs review. A page written as part of an ingest you approved starts `active`, because your approval *is* the readiness gate. **Status and confidence are independent:** status answers "may this be cited?", confidence answers "how sure are we?". Claude proposes confidence conservatively (`low` by default), and you can override it.

---

## 5. Operations

### 5.1 Ingest (the main loop)

When you drop in a source (a paste, a link, or a file in `inbox/`):

1. **Read it.** Claude reads the full source, not just snippets.
2. **Discuss takeaways first.** Before writing anything, Claude tells you:
   - what the source is actually about, in 1–3 sentences
   - its 3–5 key claims or patterns
   - where it connects to, contradicts or extends the existing wiki
   - what's *not* worth filing
3. **You approve the plan.** Say go, change it, or kill it.
4. **Then Claude writes.** A typical ingest touches:
   - one `source` page
   - 1–3 new or updated wiki pages
   - `index.md`
   - one `log.md` entry
5. **Move the raw file** from `inbox/` to the right `raw/` subfolder. Never delete it.
6. **Open a PR at session end** (§5.7).

**Default to high involvement:** no wiki writing without first discussing the takeaways.

### 5.2 Query

Claude reads `index.md` and `learning.md` first, drills into the relevant pages, and cites them with wikilinks. If an answer required real synthesis, Claude **proposes filing it back** as a page. If the wiki can't answer a question, Claude says so plainly and doesn't invent an answer.

### 5.3 Lint

Ask "lint the wiki" at any time. Claude checks for:
- **orphans:** pages with no inbound links
- **stale pages:** `last-reviewed` older than 12 months for craft, older than 24 months for concepts
- **contradictions:** pages that make incompatible claims
- **weak positions:** high confidence with fewer than 2 cases
- **naked cases:** cases not linked from any position
- **orphan domain notes:** domain pages that link to no craft page
- **missing pages:** things referenced repeatedly that have no page
- **index drift:** pages missing from `index.md`, or entries pointing to deleted pages
- **dead digests:** digests that produced zero ingests

The output is a list of issues with proposed fixes. You choose which ones to act on.

### 5.4 Case writeup

You describe a situation. **Claude checks anonymization first** (§7) and refuses to proceed on identifying input. Then you discuss the structure, and Claude writes the case and links it to positions.

### 5.5 End-of-session ritual (learning capture)

At session end, Claude proposes 0–3 additions to `learning.md`, each written as `+ <terse rule> — <why>`. You approve, edit or reject each one. Zero is a valid and common answer.

### 5.6 Weekly digest (automated gathering)

A Claude Code **cloud routine** runs weekly and opens a PR that adds a tiered digest to `digests/`. It runs in Anthropic's cloud against the GitHub repo, so your computer can be off. Wiring is described in `_meta/digest-routine-setup.md`, and the content rules in `_meta/digest-spec.md`.

**Boundary:** the digest is a *menu of pointers*, not a source. It never ingests, never writes to `inbox/`, `raw/` or wiki pages. Its only write outside `digests/` is append-only *proposed* `defer` entries in `log.md`, which take effect only when you merge the PR.

The flow:
1. The routine writes `digests/digest-YYYY-MM-DD.md` on branch `claude/digest-YYYY-MM-DD` and opens a PR.
2. You review it, check any proposed defers, and merge it.
3. If the ⭐ is an article, run the ingest loop (§5.1), starting from the digest's 🧰 ingest kit.
4. If that session produced an ingest, it ends with a PR (§5.7).

### 5.7 Git workflow (PR per session)

**Hard rule:** Claude never pushes to `main` and never merges PRs. You review and merge. Local commits are fine. Three free layers back this up; see `_meta/main-protection.md`.

1. **Session start:** run `git checkout main && git pull`. If there are uncommitted changes, ask before touching them.
2. **Before the first write:** create a branch named `ingest/YYYY-MM-DD-<slug>`, or `schema/…` or `lint/…` for other kinds of session.
3. **During the session:** commit locally at natural checkpoints.
4. **At session end, after §5.5:** push the branch and run `gh pr create --base main`. The PR body lists:
   - the sources ingested
   - the pages created or updated
   - changes to `index.md`, `log.md` and `learning.md`
   - anything deferred
5. **Give the user the link and stop there.** Merging is your review step.

---

## 6. The "challenge me" clause

You want to be challenged and to think from first principles. Claude pushes back when:
- a source is being filed without real engagement ("interesting article" is not a takeaway)
- synthesis is shallow, such as the same idea under three page names
- a `pattern` gets `confidence: high` after one read, when craft depth comes from application
- a domain note doesn't connect back to a transferable craft lesson
- a case is written about something too recent (§7)

Claude doesn't soften these challenges into vague suggestions. It states the issue, names what would fix it, and waits.

---

## 7. Privacy rules for work content

These are hard rules. A single chat message can't override them; only a deliberate edit to this file can.

- **No names:** no client names (use generic descriptors, e.g. "mid-size logistics company"), no project names or codenames, and no colleague names.
- **Rough numbers:** scrub numbers to order of magnitude or ranges, e.g. "a team of ~10".
- **Generalize the industry** one level up if the niche would identify the organization.
- **Cooling period:** at least {{30}} days between an event and a case about it.
- **On violation:** Claude refuses, names the rule, and asks for a cleaned version. It doesn't silently scrub the content and carry on.

---

## 8. Language

Wiki content is written in {{English}}. You may chat in any language. Verbatim non-English quotes stay in `raw/`.

---

## 9. Index, log, and learning conventions

### 9.1 `index.md`
The content catalog, organized by section. Each entry looks like `- [[page-name]] — one-line summary (status, confidence)`. Updated on every ingest.

### 9.2 `log.md`
An append-only record. Every entry starts with `## [YYYY-MM-DD] <action> | <subject>`, followed by 1–3 bullets. Actions are `ingest`, `query`, `lint`, `case`, `position`, `schema-update`, `learning` and `defer`.

`defer` records a decision *not* to act, and why. The weekly digest reads `defer` entries and stops re-surfacing those items. A deferral is an answer. Check recent activity with `grep "^## \[" log.md | tail -20`.

### 9.3 `learning.md`
A short, lossy file of rules learned from experience. **Cap: ~50 entries.** When it's full, Claude must consolidate, promote an entry into this file, or strike one before adding another. Entry format: `- [YYYY-MM-DD] <terse rule> — <why>`. An entry that survives about 3 sessions is a candidate for promotion into this file.

---

## 10. Tooling notes

- **Claude Code** reads and writes the vault directly. File operations and schema edits happen here.
- **Claude Code cloud routines** handle scheduled tasks (the weekly digest). They run on a fresh clone of the GitHub repo and deliver their output as PRs.
- **claude.ai chat** is for thinking and designing, and has no live access to the vault.
- **Obsidian** (optional) is for reading. The Web Clipper can save straight into `inbox/`, and frontmatter is Dataview-friendly.

---

## 11. Open questions / things to revisit

(Add to this section whenever something comes up that the schema doesn't handle yet.)

-

---

## Changelog

- **v0.1 — {{DATE}}** — Created from the second-brain-vault-template.

*Edited deliberately, not casually.*
