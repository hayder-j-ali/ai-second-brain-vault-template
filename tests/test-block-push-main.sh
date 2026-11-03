#!/bin/bash
# Regression tests for claude/hooks/block-push-main.sh (layer 1 of main protection).
# Usage: tests/test-block-push-main.sh [path-to-hook]   (default: the copy in this repo)
# Builds two throwaway repos (one on main, one on a feature branch) and pipes synthetic
# PreToolUse payloads into the hook. Nothing is pushed anywhere.

set -u
HERE="$(cd "$(dirname "$0")/.." && pwd)"
H="${1:-$HERE/claude/hooks/block-push-main.sh}"
command -v jq >/dev/null || { echo "jq is required"; exit 1; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
M="$TMP/onmain"; F="$TMP/onfeat"
mkdir -p "$M" "$F"
git -C "$M" init -q -b main; git -C "$F" init -q -b ingest/x

pass=0; fail=0
t() {
  jq -nc --arg c "$2" --arg d "$3" '{tool_name:"Bash",tool_input:{command:$c},cwd:$d}' | bash "$H" 2>/dev/null
  r=$?; [ $r = 2 ] && g=block || g=allow
  if [ "$g" = "$1" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL expected=$1 got=$g: $2"; fi
}

t block "git push" "$M"
t block "git push origin" "$M"
t block "git push -u origin HEAD" "$M"
t block "git push origin main" "$F"
t block "git push origin HEAD:main" "$F"
t block "git push --force origin main" "$F"
t block "git push origin feature:master" "$F"
t block "git push origin +refs/heads/main" "$F"
t block "git push --all" "$F"
t block "cd $M && git push" "$F"
t block "git -C $M push" "$F"
t block "git add . && git commit -m x && git push" "$M"
t block "gh pr merge 3 --squash" "$F"
t block "gh repo create x --private --push" "$F"
t block "git checkout main && git push" "$F"
t block "git switch master; git push origin" "$F"
t block "$(printf 'git commit -m "feature work"\ngit push origin main')" "$F"
t allow "git push" "$F"
t allow "git push -u origin HEAD" "$F"
t allow "git push -u origin ingest/2026-01-01-foo" "$M"
t allow "git push origin maintenance-fix" "$M"
t allow "git push -u origin HEAD:ingest/x" "$M"
t allow "cd $F && git push" "$M"
t allow "git checkout -b ingest/new && git push -u origin HEAD" "$M"
t allow "git status" "$M"
t allow "gh pr create --fill" "$M"
t allow "git commit -m 'never push to main'" "$M"
t allow "git checkout -- file.md" "$M"
t allow "$(printf 'cat >> log.md <<EOF\n- never push to main\nEOF\ngit commit -q -m x\ngit push -u origin schema/x')" "$M"

echo "pass=$pass fail=$fail"
[ "$fail" = 0 ]
