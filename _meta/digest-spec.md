---
created: {{DATE}}
modified: {{DATE}}
type: meta
status: active
---

# Digest spec

This is the canonical spec for the weekly digest produced by the cloud routine, and **it is the single source of truth.** The routine prompt (`routine/digest-prompt.md`) only handles the cloud and git mechanics, then tells the run to read and follow this file. If they conflict, this file wins. Edit this file to change what the digest does; the next run picks it up from `main`.

---

## ⚙️ Your configuration (edit this section)

> Replace the `{{…}}` values below. Everything after this section works as-is. For a filled-in version, see `examples/analytics-engineering/digest-config.md`.

- **Who it's for:** {{one line, e.g. "an independent product designer building a consulting practice"}}
- **Cadence:** weekly, {{DAY HH:MM TIMEZONE, e.g. "Sunday 13:00 Europe/London"}}, delivered as a PR on branch `claude/digest-YYYY-MM-DD`.
- **Model:** {{e.g. claude-sonnet-5-5}}. This is routine gathering and doesn't need the largest model.

**Source priority** (highest weight first):
1. **{{CORE CRAFT}}:** {{the methods and techniques that travel to every project}}
2. **{{CRAFT × AI, or another intersection you care about}}:** {{…}}
3. **Structural shifts:** {{major moves in your field's tools, standards or institutions that change what you'd recommend}}
4. **Demand signals:** {{what the people you serve are buying, asking for or paying for, e.g. rate surveys, RFPs and tenders, job and contract postings, service-line launches}}

**Out of scope:** {{e.g. specific domains you have no live project in; generic AI hype; funding news}}

---

## Purpose

A weekly, pre-filtered menu of developments, tiered by relevance to the moat in CLAUDE.md §1. The digest **gathers and triages**; it does **not** ingest. Deciding what enters the second brain stays a human-plus-Claude conversation (CLAUDE.md §5.1).

**Two readers, one document, two parts.**
- **The scan** (~300 words, ⭐ first) is for the user's 60-second weekly read.
- **The ingest kit** below it is for the later ingest session: pre-drafted takeaways and a page plan for the ⭐ article, so ingesting becomes mostly approval.

**The real scorecard is conversion.** A digest is only useful if its ⭐ picks turn into ingests. That's why the ⭐ must pass the worth-your-time test, and why every article ⭐ comes with an ingest kit.

## Step 0: read the vault before writing (mandatory)

The digest is written **into a live wiki, not a void.** Before gathering or ranking anything, read:

1. `index.md`, the full catalog of existing pages.
2. The **last 3 digests**, including any that only exist in unmerged `claude/digest-*` PRs (the routine fetches them).
3. The tail of `log.md` (`grep "^## \[" log.md | tail -20`). **Check for `defer` entries.** A deferred item is answered: don't re-press it.

A digest written without this step repeats itself and recommends pages that already exist.

## The belief-change test (the bar for 🔴/🟡)

An item earns a tier only if it changes **what you'd recommend or believe about the craft.** "A thing shipped" is not enough. Ask: *if this is true, what page do I write or change?* If the answer is "none", it goes in Skip.

## The worth-your-time test (the bar for ⭐)

The ⭐ must clearly meet **at least one** of these criteria, and the digest names which:
- **Usable now:** something you could use in real work within about a month, such as an approach, a pattern or a pitch angle.
- **Builds a position:** evidence that sharpens one of your own opinions or frameworks (`positions/`), whether it supports or challenges it.
- **Hands-on craft:** a concrete technique with a worked example you can try, not commentary about one.
- **Contrarian or new:** it challenges what the vault currently believes.

Prefer a pick that meets two or more. If nothing meets even one, say so and pick from the ledger instead.

## Anti-repetition

An item **already covered in a prior digest doesn't get a fresh tier slot.** It moves to the 🕓 ledger. If nothing new happened, the tiers can be empty. That's an honest digest.

## Decision-forcing and the ledger

When a theme has appeared for **3+ weeks**, stop re-recommending it and state the decision the user owes. Escalate with age: week 3 is a flag, and weeks 4–5 are "this is becoming a debt". Don't re-argue the evidence; link back to the digest that made the case. Each ledger line is **one sentence of 25 words or fewer**, plus the link back.

### Proposed defer (how items leave the ledger)

At **6 weeks** with no `ingest` or `defer` in `log.md`, the digest stops escalating and **proposes a deferral**:
1. **In the 🕓 ledger,** mark the item `→ proposed defer (merge to accept)`.
2. **In the same PR,** append a `defer` entry to `log.md`. It's append-only, so never edit existing lines:
   ```
   ## [YYYY-MM-DD] defer | <theme>

   - Proposed by the weekly digest after <N> weeks in the ledger with no decision. Accepted by merging digest PR.
   - Unblock when wanted: <the one concrete next step>.
   ```
3. **Merging the PR accepts the deferral.** To reject it, delete the entry in the PR before merging.

Once deferred, the item **leaves the ledger.** It comes back only if a genuinely new 🔴-grade development appears, and then only as a new item that links the old defer. **Never** declare an item deferred any other way. There's no "deferred by silence".

## Source rules

- **Weighting:** follow the source priority in your configuration.
- **Deprioritize hard:** generic AI product launches, benchmark races, model-release hype, and funding news with no angle on your craft.
- **Demand signals bar:** an item must be dated and traceable, and name a concrete demand (what's being bought, by whom). Numbers are a plus. **Auto-skip:** "make $X/month" blueprints, income listicles, course marketing, undated thought-leadership, and anything backed only by one anonymous testimonial. **Max 2 per digest.**

## Output format

The **scan**, everything above the `---`, should be **~300 words** with the ⭐ first. The **ingest kit** is 250 words or fewer, and only appears when the ⭐ is an article. The **Skip** list is 60 words or fewer.

```markdown
# Digest — YYYY-MM-DD

## ⭐ This week's one recommended action
[Exactly one: an article to ingest (URL + the page it becomes), a page to draft, or a vault decision. Name the specific thing.]
Why it's worth your time: [usable now | builds a position | hands-on craft | contrarian/new]. [One sentence.]

## 🔴 Structural — new this week
- **[Headline].** [One sentence.] → [[existing-page]] or GAP. Implies: [page-shaped output]. [URL]

## 🟡 Thematic — new this week
- **[Headline].** [One sentence.] → [[existing-page]] or GAP. Implies: [...]. [URL]
- 💶 **[Demand signal].** [What's being bought, by whom, at what rate if known.] → [[page]] or GAP. [URL]

## 🕓 Still open
- [Theme] — [N] wks (first: digest-YYYY-MM-DD). [≤25 words: status + ask.] [→ proposed defer (merge to accept)]

---

## 🧰 Ingest kit — for the ⭐ article (skip if not reading)
- **Source:** [title, author, date, URL]
- **About (1–2 sentences):** [...]
- **Key claims (3–5):** [...]
- **Connects / contradicts:** [[page]] — [how]
- **Not worth filing:** [the noise]
- **Page plan:** [create/update which pages, page type, one line each]

## ⚪ Skip
- [Headline] — [reason, ≤5 words]

*Reviewed X · new Y · carried Z · proposed defers N*
```

## Rules for the digest writer

- **Step 0 first.** A digest that doesn't reference the index and the prior digests is malformed.
- **Word budgets:** cutting is the job. Cadence notes, methodology asides and re-argued evidence are padding.
- **Limits:** max 3 items in 🔴 and max 3 in 🟡, new items only. Max 2 💶 demand signals.
- **Exactly one ⭐.** It can be an article, a draft or a decision, but it must name the specific thing and pass the worth-your-time test. **Prefer an article that passes.**
- **The ingest kit is mandatory** when the ⭐ is an article. It's a *draft for discussion* and writes nothing to the wiki.
- **No per-item relevance ratings.** Tier placement is the signal.
- **Every tiered item gets a real URL and a vault connection.** One quote max per source, under 15 words.
- **Files the run may touch:** the new `digests/digest-YYYY-MM-DD.md`, plus append-only proposed `defer` entries in `log.md`. Nothing else.
- **A quiet week is a good digest:** still give one ⭐ (fall back to the ledger) and keep it short.

## What the user does with it

1. **Read the PR:** open it and read the ⭐ first (about 60 seconds).
2. **Check proposed defers** in the `log.md` diff. Merging accepts them; deleting an entry rejects it.
3. **Merge**, so local sessions and next week's run see it.
4. **Ingest the article:** if the ⭐ is an article, start an ingest session with "ingest the ⭐ from digest-YYYY-MM-DD". Claude starts from the ingest kit.
