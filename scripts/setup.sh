#!/bin/bash
# One-time setup for a vault created from this template.
#   scripts/setup.sh                        # layer 2: enable the versioned pre-push hook in this clone
#   scripts/setup.sh --install-claude-hook  # also layer 1: install the Claude Code block-push hook into ~/.claude
# Safe to re-run. It never edits ~/.claude/settings.json without making a timestamped backup first.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== Layer 2: git pre-push hook"
git config core.hooksPath .githooks
chmod +x .githooks/pre-push
echo "   core.hooksPath = $(git config --get core.hooksPath)"

if [ "${1:-}" = "--install-claude-hook" ]; then
  echo "== Layer 1: Claude Code hook"
  command -v jq >/dev/null || { echo "   jq is required (brew install jq / apt install jq)"; exit 1; }
  mkdir -p "$HOME/.claude/hooks"
  install -m 0755 claude/hooks/block-push-main.sh "$HOME/.claude/hooks/block-push-main.sh"
  echo "   installed ~/.claude/hooks/block-push-main.sh"

  S="$HOME/.claude/settings.json"
  [ -f "$S" ] || echo '{}' > "$S"
  if jq -e '[.hooks.PreToolUse[]?.hooks[]?.command] | any(test("block-push-main.sh"))' "$S" >/dev/null 2>&1; then
    echo "   settings.json already references the hook; leaving it alone"
  else
    cp "$S" "$S.bak-$(date +%Y%m%d%H%M%S)"
    tmp="$(mktemp)"
    jq --slurpfile snip claude/settings-snippet.json \
       '.hooks.PreToolUse = ((.hooks.PreToolUse // []) + $snip[0].hooks.PreToolUse)' "$S" > "$tmp" && mv "$tmp" "$S"
    echo "   added PreToolUse hook to ~/.claude/settings.json (backup saved next to it)"
  fi

  echo "== Testing layer 1"
  tests/test-block-push-main.sh "$HOME/.claude/hooks/block-push-main.sh"
fi

cat <<'EOF'

Done. Next steps:
  1. Fill in CLAUDE.md §1 and the ⚙️ section of _meta/digest-spec.md (search for "{{").
  2. Commit on a branch, push, open a PR, merge it on GitHub.
  3. Create the weekly digest routine: see _meta/digest-routine-setup.md.
  4. Layer 3 (guard-main Action) is already active once .github/ is on main.
EOF
