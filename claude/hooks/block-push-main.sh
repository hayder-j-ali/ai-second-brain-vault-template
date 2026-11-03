#!/bin/bash
# PreToolUse hook (Bash): block pushes/merges that land directly on main/master.
# Policy: Claude commits locally, pushes feature branches, opens PRs. The user reviews and merges.
# Exit 2 = block; stderr is shown to Claude.

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
[ -z "$cmd" ] && exit 0

block() {
  echo "BLOCKED by ~/.claude/hooks/block-push-main.sh: $1" >&2
  echo "Policy: never push or merge to main/master. Push a feature branch and open a PR with 'gh pr create'; the user reviews and merges." >&2
  exit 2
}

# Split into shell segments (newlines, ;, &&, ||, |) so text in commit messages or heredocs
# can't trigger or mask a match. Track the most recent `cd` for implicit-branch checks.
dir="$cwd"
segments=$(printf '%s\n' "$cmd" | tr ';|&' '\n\n\n')

while IFS= read -r seg; do
  seg="${seg#"${seg%%[![:space:]]*}"}"   # ltrim
  [ -z "$seg" ] && continue

  # Remember directory changes: `cd <dir>`.
  if [[ "$seg" =~ ^cd[[:space:]]+(\"[^\"]+\"|[^[:space:]]+) ]]; then
    d="${BASH_REMATCH[1]}"; d="${d#\"}"; d="${d%\"}"; d="${d/#\~/$HOME}"
    case "$d" in /*) dir="$d" ;; *) dir="$dir/$d" ;; esac
    continue
  fi

  # Remember branch switches earlier in the same command: `git checkout|switch [-b|-c|-B|-C] <branch>`.
  if [[ "$seg" =~ ^git[[:space:]]+(checkout|switch)[[:space:]]+(-[bBcC][[:space:]]+)?([^-[:space:]][^[:space:]]*)[[:space:]]*$ ]]; then
    assumed_branch="${BASH_REMATCH[3]}"
    continue
  fi

  # PR merges and repo-create-with-push are the user's job.
  [[ "$seg" =~ ^gh[[:space:]]+pr[[:space:]]+merge([[:space:]]|$) ]] && block "gh pr merge"
  [[ "$seg" =~ ^gh[[:space:]]+repo[[:space:]]+create[[:space:]].*--push ]] && block "gh repo create --push pushes the default branch"

  # git [-C dir] push ...
  [[ "$seg" =~ ^git[[:space:]]+(-C[[:space:]]+(\"[^\"]+\"|[^[:space:]]+)[[:space:]]+)?push([[:space:]]|$)(.*)$ ]] || continue
  segdir="$dir"
  if [ -n "${BASH_REMATCH[2]}" ]; then
    d="${BASH_REMATCH[2]}"; d="${d#\"}"; d="${d%\"}"; d="${d/#\~/$HOME}"
    case "$d" in /*) segdir="$d" ;; *) segdir="$dir/$d" ;; esac
  fi
  args="${BASH_REMATCH[4]}"

  positional=0
  explicit_feature=0
  implicit=1
  for a in $args; do
    case "$a" in
      (--all|--mirror) block "push --all/--mirror includes main/master" ;;
      (-*) ;;
      (*) positional=$((positional + 1))
          [ "$positional" -lt 2 ] && continue          # 1st positional = remote
          dst="${a##*:}"; dst="${dst#+}"; dst="${dst#refs/heads/}"
          case "$dst" in
            (main|master) block "push targets '$dst'" ;;
            (HEAD) ;;                                   # resolves to current branch
            (*) implicit=0; explicit_feature=1 ;;
          esac ;;
    esac
  done

  if [ "$implicit" = 1 ]; then
    branch="${assumed_branch:-$(git -C "$segdir" branch --show-current 2>/dev/null)}"
    case "$branch" in
      (main|master) block "current branch is '$branch' and the push names no feature branch" ;;
    esac
  fi
done <<< "$segments"
exit 0
