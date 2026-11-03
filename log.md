# Log

An append-only chronological record. Entry format: `## [YYYY-MM-DD] <action> | <subject>`, followed by 1–3 bullets. Actions are `ingest`, `query`, `lint`, `case`, `position`, `schema-update`, `learning` and `defer`. See CLAUDE.md §9.2.

Check recent activity with `grep "^## \[" log.md | tail -20`

## [{{DATE}}] schema-update | vault created from template
- Initialized from second-brain-vault-template. CLAUDE.md §1 still needs your own goals.
