#!/usr/bin/env bash
# spawn-monks.sh — Spawn Monk A and Monk B in parallel
#
# Usage:
#   ./spawn-monks.sh <session_dir> [--model <model>]
#
# Reads monk_a_prompt.md and monk_b_prompt.md from <session_dir>
# Writes monk_a_output.md and monk_b_output.md to <session_dir>
#
# Requires: claude CLI (https://claude.ai/code)
# Optional: --model flag overrides default model for both monks
#
# Heterogeneous models (different families for A vs B) increase decorrelation:
#   MONK_A_MODEL=claude-opus-4 MONK_B_MODEL=gemini-2.5-pro ./spawn-monks.sh ./session

set -euo pipefail

SESSION_DIR="${1:?Usage: $0 <session_dir> [--model <model>]}"
MODEL="${MODEL:-}"

# Allow per-monk model override via env
MONK_A_MODEL="${MONK_A_MODEL:-${MODEL}}"
MONK_B_MODEL="${MONK_B_MODEL:-${MODEL}}"

PROMPT_A="${SESSION_DIR}/monk_a_prompt.md"
PROMPT_B="${SESSION_DIR}/monk_b_prompt.md"
OUTPUT_A="${SESSION_DIR}/monk_a_output.md"
OUTPUT_B="${SESSION_DIR}/monk_b_output.md"

if [[ ! -f "$PROMPT_A" ]]; then
  echo "ERROR: $PROMPT_A not found. Generate monk prompts first." >&2
  exit 1
fi

if [[ ! -f "$PROMPT_B" ]]; then
  echo "ERROR: $PROMPT_B not found. Generate monk prompts first." >&2
  exit 1
fi

echo "Spawning monks in parallel..."
echo "  Monk A → $OUTPUT_A"
echo "  Monk B → $OUTPUT_B"

spawn_monk() {
  local label="$1"
  local prompt_file="$2"
  local output_file="$3"
  local model_flag=""

  if [[ -n "${4:-}" ]]; then
    model_flag="--model $4"
  fi

  echo "[${label}] Starting..."
  # shellcheck disable=SC2086
  claude -p $model_flag \
    --allowedTools "web_search,web_fetch,read_file" \
    < "$prompt_file" \
    > "$output_file"
  echo "[${label}] Done → $output_file"
}

# Run in parallel
spawn_monk "Monk A" "$PROMPT_A" "$OUTPUT_A" "$MONK_A_MODEL" &
PID_A=$!

spawn_monk "Monk B" "$PROMPT_B" "$OUTPUT_B" "$MONK_B_MODEL" &
PID_B=$!

# Wait for both; capture exit codes
EXIT_A=0
EXIT_B=0
wait "$PID_A" || EXIT_A=$?
wait "$PID_B" || EXIT_B=$?

echo ""
if [[ $EXIT_A -ne 0 ]]; then
  echo "ERROR: Monk A failed (exit $EXIT_A). Check $OUTPUT_A." >&2
fi

if [[ $EXIT_B -ne 0 ]]; then
  echo "ERROR: Monk B failed (exit $EXIT_B). Check $OUTPUT_B." >&2
fi

if [[ $EXIT_A -ne 0 || $EXIT_B -ne 0 ]]; then
  exit 1
fi

echo "Both monks complete."
echo ""
echo "Next steps:"
echo "  1. Read $OUTPUT_A and $OUTPUT_B"
echo "  2. Decorrelation check: different frameworks, not just conclusions?"
echo "  3. If either monk hedges: restart with revised prompt (don't nudge)"
echo "  4. Present to user with explanation, ask about untested claims"
