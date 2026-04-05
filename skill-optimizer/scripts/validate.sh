#!/usr/bin/env bash
set -uo pipefail

# Validate any AI skill against Anthropic best practices + harness principles.
#
# Usage:
#   bash validate.sh <skill-dir>      Validate a specific skill
#   bash validate.sh                   Validate the skill-optimizer itself
#
# Exit codes: 0 = pass, 1 = fail
# Output: structured report with ✅/❌/⚠️ per check

SKILL_DIR="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
ERRORS=0
WARNINGS=0

pass()  { echo "  ✅ $1"; }
fail()  { echo "  ❌ $1"; ((ERRORS++)) || true; }
warn()  { echo "  ⚠️  $1"; ((WARNINGS++)) || true; }

# --- Pre-flight ---
echo "=== Validating: $SKILL_DIR ==="

if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  fail "SKILL.md not found at $SKILL_DIR/SKILL.md"
  echo ""
  echo "RESULT: FAIL (cannot continue without SKILL.md)"
  exit 1
fi

# --- 1. Frontmatter ---
echo ""
echo "1. Frontmatter"

head -1 "$SKILL_DIR/SKILL.md" | grep -q '^---$' \
  && pass "Opens with ---" \
  || fail "Must start with --- on line 1 (no blank lines before)"

# Extract name field
name_line=$(grep '^name:' "$SKILL_DIR/SKILL.md" || true)
if [ -n "$name_line" ]; then
  pass "name field present"
  skill_name=$(echo "$name_line" | sed 's/^name: *//')
  dir_name=$(basename "$SKILL_DIR")
  if [ "$skill_name" = "$dir_name" ]; then
    pass "name matches directory ($skill_name)"
  else
    warn "name '$skill_name' differs from directory '$dir_name'"
  fi
  # Validate name format: lowercase, hyphens, no consecutive hyphens
  if echo "$skill_name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    pass "name format valid (lowercase-hyphens)"
  else
    fail "name '$skill_name' invalid — must match ^[a-z0-9]+(-[a-z0-9]+)*$"
  fi
else
  fail "Missing name: field"
fi

# Extract and validate description
desc_line=$(grep '^description:' "$SKILL_DIR/SKILL.md" || true)
if [ -n "$desc_line" ]; then
  pass "description field present"
  desc=$(echo "$desc_line" | sed 's/^description: *//' | tr -d '"')
  desc_len=${#desc}
  if [ "$desc_len" -lt 50 ]; then
    warn "Description is $desc_len chars (recommend ≥50 for activation)"
  elif [ "$desc_len" -gt 250 ]; then
    warn "Description is $desc_len chars (agents truncate at ~250 in skill listings)"
  else
    pass "Description length: $desc_len chars (within 50-250 sweet spot)"
  fi
  # Check description is third person (not "I can" or "You can")
  if echo "$desc" | grep -qiE '\bI can\b|\bI help\b|\bYou can\b'; then
    fail "Description uses first/second person — must be third person"
  else
    pass "Description in third person"
  fi
else
  fail "Missing description: field"
fi

# --- 2. File sizes ---
echo ""
echo "2. File sizes"

find "$SKILL_DIR" -name '*.md' -type f | while IFS= read -r f; do
  lines=$(wc -l < "$f" | tr -d ' ')
  fname=$(basename "$f")
  if [ "$fname" = "SKILL.md" ] && [ "$lines" -gt 500 ]; then
    fail "$fname: $lines lines (max 500 per Anthropic docs)"
  elif [ "$fname" != "SKILL.md" ] && [ "$lines" -gt 200 ]; then
    fail "$fname: $lines lines (max 200 for reference files)"
  else
    pass "$fname: $lines lines"
  fi
done

# --- 3. Link integrity ---
echo ""
echo "3. Link integrity"

link_count=0
while IFS= read -r link; do
  # Skip external URLs
  case "$link" in http://*|https://*) continue;; esac
  if [ -f "$SKILL_DIR/$link" ]; then
    pass "→ $link"
  else
    fail "Broken link: $link"
  fi
  link_count=$((link_count + 1))
done < <(grep -oE '\[.*?\]\([^)]+\)' "$SKILL_DIR/SKILL.md" | grep -oE '\([^)]+\)' | tr -d '()' 2>/dev/null || true)
if [ "$link_count" -eq 0 ]; then
  warn "No internal links found — consider adding references for progressive disclosure"
fi

# --- 4. Nesting depth (max 1 level from SKILL.md) ---
echo ""
echo "4. Reference nesting"

nested=0
if [ -d "$SKILL_DIR/references" ]; then
  for ref in "$SKILL_DIR"/references/*.md; do
    [ -f "$ref" ] || continue
    if grep -qE '\[.*\]\((references|\.\./)' "$ref" 2>/dev/null; then
      fail "$(basename "$ref") links to another reference (Anthropic says max 1 level deep)"
      nested=1
    fi
  done
fi
[ "$nested" -eq 0 ] && pass "All references one level deep from SKILL.md"

# --- 5. Reference hygiene ---
echo ""
echo "5. Reference hygiene"

if [ -d "$SKILL_DIR/references" ]; then
  for ref in "$SKILL_DIR"/references/*.md; do
    [ -f "$ref" ] || continue
    if head -1 "$ref" | grep -q '^---$'; then
      fail "$(basename "$ref") has YAML frontmatter (wastes tokens — only SKILL.md needs it)"
    else
      pass "$(basename "$ref") — clean (no frontmatter)"
    fi
  done
else
  pass "No references/ directory (simple skill)"
fi

# --- 6. Harness quality ---
echo ""
echo "6. Harness quality (activation signals)"

# Check for non-negotiables or acceptance criteria
if grep -qiE 'non.negotiable|acceptance.criteria|must.pass' "$SKILL_DIR/SKILL.md"; then
  pass "Has non-negotiable / acceptance criteria section"
else
  warn "No non-negotiable section — skill may produce inconsistent results"
fi

# Check for output format
if grep -qiE 'output.format|output template|produces.*artifact' "$SKILL_DIR/SKILL.md"; then
  pass "Has output format defined"
else
  warn "No output format section — models may produce inconsistent output"
fi

# Check for examples
example_count=$(grep -ciE 'example|before.*after' "$SKILL_DIR/SKILL.md" || true)
if [ "$example_count" -ge 1 ]; then
  pass "Contains examples ($example_count references)"
else
  warn "No examples found — add ≥1 before/after example per core capability"
fi

# --- 7. Soft language audit ---
echo ""
echo "7. Language audit"

soft_found=0
ref_files=()
if [ -d "$SKILL_DIR/references" ]; then
  for r in "$SKILL_DIR"/references/*.md; do [ -f "$r" ] && ref_files+=("$r"); done
fi
for f in "$SKILL_DIR/SKILL.md" ${ref_files[@]+"${ref_files[@]}"}; do
  [ -f "$f" ] || continue
  # Search for soft language, exclude lines that are teaching about soft language
  while IFS= read -r match; do
    # Skip table cells (before/after comparisons), diff lines, quoted strings, example blocks
    case "$match" in
      *'|'*'|'*) continue ;;   # table row
      *'"'*) continue ;;       # quoted example
      *'Before'*|*'before'*|*'Replace'*|*'fuzzy'*|*'Bad'*|*'zero instances'*|*'example'*) continue ;;
      *'- '*) continue ;;      # list item in example
    esac
    warn "Soft language in $(basename "$f"): $match"
    soft_found=1
  done < <(grep -n -iE '\b(consider using|you may want|optionally|try to include|when possible)\b' "$f" 2>/dev/null || true)
done
[ "$soft_found" -eq 0 ] && pass "No soft language outside examples"

# --- Summary ---
echo ""
echo "================================="
total_md=$(find "$SKILL_DIR" -name '*.md' -type f | wc -l | tr -d ' ')
total_words=0
for f in $(find "$SKILL_DIR" -name '*.md' -type f); do
  w=$(wc -w < "$f" | tr -d ' ')
  total_words=$((total_words + w))
done
echo "Files: $total_md markdown | ~$((total_words * 4 / 3)) estimated tokens"
echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAIL — $ERRORS error(s), $WARNINGS warning(s)"
  exit 1
elif [ "$WARNINGS" -gt 0 ]; then
  echo "RESULT: PASS — $WARNINGS warning(s)"
  exit 0
else
  echo "RESULT: PASS — all checks clean"
  exit 0
fi
