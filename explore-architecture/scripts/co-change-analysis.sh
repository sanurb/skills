#!/usr/bin/env bash
set -euo pipefail

# Analyzes git history to find files that frequently change together.
# Outputs clusters of co-changing files sorted by frequency.
#
# Usage: co-change-analysis.sh [repo-path] [--since=6months] [--min-freq=3]
#
# Arguments:
#   repo-path   Path to the git repository (default: current directory)
#   --since     How far back to look (default: 6 months). Passed to git log --since.
#   --min-freq  Minimum co-change frequency to report (default: 3)

REPO_PATH="${1:-.}"
SINCE="6 months ago"
MIN_FREQ=3

for arg in "$@"; do
  case "$arg" in
    --since=*) SINCE="${arg#--since=}" ;;
    --min-freq=*) MIN_FREQ="${arg#--min-freq=}" ;;
  esac
done

if [[ ! -d "$REPO_PATH/.git" ]]; then
  echo "Error: '$REPO_PATH' is not a git repository" >&2
  exit 1
fi

cd "$REPO_PATH"

COMMIT_COUNT=$(git rev-list --count --since="$SINCE" HEAD 2>/dev/null || echo 0)
if [[ "$COMMIT_COUNT" -eq 0 ]]; then
  echo "Error: No commits found since '$SINCE'" >&2
  exit 1
fi

echo "=== Co-Change Analysis ==="
echo "Repository: $(basename "$(pwd)")"
echo "Period: since $SINCE ($COMMIT_COUNT commits)"
echo ""

echo "--- Most frequently changed files ---"
git log --since="$SINCE" --pretty=format: --name-only \
  | grep -v '^$' \
  | sort \
  | uniq -c \
  | sort -rn \
  | head -30

echo ""
echo "--- Files that change together (co-change pairs) ---"

TMPDIR_PATH=$(mktemp -d)
trap 'rm -rf "$TMPDIR_PATH"' EXIT

git log --since="$SINCE" --pretty=format:"COMMIT_SEP" --name-only \
  | awk '
    /^COMMIT_SEP$/ {
      for (i = 0; i < n; i++)
        for (j = i + 1; j < n; j++)
          if (files[i] != files[j])
            print (files[i] < files[j]) ? files[i] " <-> " files[j] : files[j] " <-> " files[i]
      n = 0
      next
    }
    /^$/ { next }
    {
      files[n++] = $0
    }
  ' \
  | sort \
  | uniq -c \
  | sort -rn \
  | awk -v min="$MIN_FREQ" '$1 >= min' \
  | head -40

echo ""
echo "--- Directory-level coupling (top co-changing directory pairs) ---"
git log --since="$SINCE" --pretty=format:"COMMIT_SEP" --name-only \
  | awk -F'/' '
    /^COMMIT_SEP$/ {
      for (i = 0; i < n; i++)
        for (j = i + 1; j < n; j++)
          if (dirs[i] != dirs[j])
            print (dirs[i] < dirs[j]) ? dirs[i] " <-> " dirs[j] : dirs[j] " <-> " dirs[i]
      n = 0
      next
    }
    /^$/ { next }
    NF >= 2 {
      dirs[n++] = $1 "/" $2
    }
    NF == 1 {
      dirs[n++] = $1
    }
  ' \
  | sort \
  | uniq -c \
  | sort -rn \
  | awk -v min="$MIN_FREQ" '$1 >= min' \
  | head -20
