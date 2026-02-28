#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_DANGEROUS:=0}"
: "${ACCEPT_STRING_COMMANDS:=1}"     # 0 = block .command. 1 = allow legacy substring checks
: "${BLOCK_GIT_PUSH:=1}"
: "${BLOCK_FORCE_PUSH_ONLY:=0}"      # only if BLOCK_GIT_PUSH=0
: "${BLOCK_RESET_HARD:=1}"
: "${BLOCK_CLEAN_FORCE:=1}"
: "${BLOCK_BRANCH_D:=1}"
: "${BLOCK_RESTORE_DOT:=1}"
: "${BLOCK_SWITCH_FORCE:=1}"

die_block() {
  printf "BLOCKED: %s\nCOMMAND: %s\n" "$1" "$2" >&2
  exit 2
}

have() { command -v "$1" >/dev/null 2>&1; }

jq_must() {
  local input="$1" filter="$2" out err
  if ! out="$(jq -cer "$filter" <<<"$input" 2> >(err="$(cat)"; printf '%s' "$err" >&2))"; then
    err="$(jq -cer "$filter" <<<"$input" 2>&1 >/dev/null || true)"
    die_block "invalid JSON or schema mismatch ($filter): ${err:-unknown}" "<raw-json>"
  fi
  printf '%s' "$out"
}

declare -A POLICY=(
  ["ALLOW_DANGEROUS"]="$ALLOW_DANGEROUS"
  ["ACCEPT_STRING_COMMANDS"]="$ACCEPT_STRING_COMMANDS"
  ["BLOCK_GIT_PUSH"]="$BLOCK_GIT_PUSH"
  ["BLOCK_FORCE_PUSH_ONLY"]="$BLOCK_FORCE_PUSH_ONLY"
  ["BLOCK_RESET_HARD"]="$BLOCK_RESET_HARD"
  ["BLOCK_CLEAN_FORCE"]="$BLOCK_CLEAN_FORCE"
  ["BLOCK_BRANCH_D"]="$BLOCK_BRANCH_D"
  ["BLOCK_RESTORE_DOT"]="$BLOCK_RESTORE_DOT"
  ["BLOCK_SWITCH_FORCE"]="$BLOCK_SWITCH_FORCE"
)

p() { [[ "${POLICY[$1]:-0}" == "1" ]]; }

strip_env_assignments() {
  local -n in="$1" out="$2"
  out=()
  local i=0
  while (( i < ${#in[@]} )); do
    [[ "${in[i]}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]] || break
    ((i++))
  done
  while (( i < ${#in[@]} )); do
    out+=("${in[i]}")
    ((i++))
  done
}

argv_has_exact_any() {
  local -n argv="$1"; shift
  local needle a
  for needle in "$@"; do
    for a in "${argv[@]}"; do
      [[ "$a" == "$needle" ]] && return 0
    done
  done
  return 1
}

argv_has_prefix_any() {
  local -n argv="$1"; shift
  local prefix a
  for prefix in "$@"; do
    for a in "${argv[@]}"; do
      [[ "$a" == "$prefix"* ]] && return 0
    done
  done
  return 1
}

argv_has_shortflag_char() {
  local -n argv="$1"
  local ch="$2"
  local a
  for a in "${argv[@]}"; do
    [[ "$a" == --* ]] && continue
    [[ "$a" =~ ^-[A-Za-z]+$ ]] || continue
    [[ "$a" == *"$ch"* ]] && return 0
  done
  return 1
}

argv_has_pathspec_dot() {
  local -n argv="$1"
  local a
  for a in "${argv[@]}"; do
    [[ "$a" == "." ]] && return 0
  done
  return 1
}

# Parses: git [global-opts...] <subcommand> [args...]
# Global opts handled: -C <path>, -c <k=v>, --git-dir <dir>, --work-tree <dir>, plus --opt=value forms.
parse_git() {
  local -n argv="$1"
  local -n subcmd="$2"
  local -n rest="$3"

  subcmd=""
  rest=()
  [[ "${argv[0]:-}" == "git" ]] || return 1

  declare -A TAKES_VALUE=( ["-C"]=1 ["-c"]=1 ["--git-dir"]=1 ["--work-tree"]=1 )

  local i=1
  while (( i < ${#argv[@]} )); do
    local t="${argv[i]}"

    [[ "$t" == "--" ]] && { ((i++)); break; }
    [[ "$t" != -* ]] && { subcmd="$t"; ((i++)); break; }

    [[ "$t" == *=* ]] && { ((i++)); continue; }

    if [[ -n "${TAKES_VALUE[$t]:-}" ]]; then
      ((i+=2))
    else
      ((i+=1))
    fi
  done

  [[ -n "$subcmd" ]] || return 1

  while (( i < ${#argv[@]} )); do
    rest+=("${argv[i]}")
    ((i++))
  done
  return 0
}

handle_push() {
  local original="$1"; shift
  local -a rest=("$@")

  p "BLOCK_GIT_PUSH" && die_block "policy forbids any 'git push'" "$original"

  if p "BLOCK_FORCE_PUSH_ONLY"; then
    argv_has_exact_any rest "-f" "--force" "--force-with-lease" && die_block "force push is forbidden" "$original"
    argv_has_prefix_any rest "--force-with-lease=" && die_block "force-with-lease push is forbidden" "$original"
  fi
}

handle_reset() {
  local original="$1"; shift
  local -a rest=("$@")
  p "BLOCK_RESET_HARD" || return 0
  argv_has_exact_any rest "--hard" && die_block "hard reset is forbidden (git reset --hard)" "$original"
}

handle_clean() {
  local original="$1"; shift
  local -a rest=("$@")
  p "BLOCK_CLEAN_FORCE" || return 0
  argv_has_exact_any rest "--force" && die_block "git clean --force is forbidden" "$original"
  argv_has_exact_any rest "-f" "-ff" "-fd" "-df" && die_block "git clean with -f is forbidden" "$original"
  argv_has_shortflag_char rest "f" && die_block "git clean with -f is forbidden (flag group)" "$original"
}

handle_branch() {
  local original="$1"; shift
  local -a rest=("$@")
  p "BLOCK_BRANCH_D" || return 0
  argv_has_exact_any rest "-D" && die_block "deleting branch forcibly is forbidden (git branch -D)" "$original"
}

handle_checkout() {
  local original="$1"; shift
  local -a rest=("$@")
  p "BLOCK_RESTORE_DOT" || return 0
  argv_has_pathspec_dot rest && die_block "checkout/restore of '.' (entire tree) is forbidden" "$original"
}

handle_restore() { handle_checkout "$@"; }

handle_switch() {
  local original="$1"; shift
  local -a rest=("$@")
  p "BLOCK_SWITCH_FORCE" || return 0
  argv_has_exact_any rest "-f" "--force" && die_block "git switch with force is forbidden" "$original"
}

declare -A GIT_DISPATCH=(
  ["push"]=handle_push
  ["reset"]=handle_reset
  ["clean"]=handle_clean
  ["branch"]=handle_branch
  ["checkout"]=handle_checkout
  ["restore"]=handle_restore
  ["switch"]=handle_switch
)

evaluate_argv() {
  local original="$1"; shift
  local -a argv=("$@")

  p "ALLOW_DANGEROUS" && return 0

  local -a stripped
  strip_env_assignments argv stripped
  [[ "${stripped[0]:-}" == "git" ]] || return 0

  local subcmd
  local -a rest
  parse_git stripped subcmd rest || return 0

  local handler="${GIT_DISPATCH[$subcmd]:-}"
  [[ -n "$handler" ]] || return 0

  "$handler" "$original" "${rest[@]}"
}

legacy_string_guard() {
  local cmd="$1"

  # Extremely conservative. Enable only if you *must* accept string commands.
  # This is intentionally strict to avoid giving a false sense of safety.
  local s="${cmd//$'\n'/ }"
  s="${s//$'\r'/ }"
  s="${s//$'\t'/ }"

  [[ "$s" == *"git reset --hard"* ]] && die_block "heuristic: contains 'git reset --hard'" "$cmd"
  [[ "$s" == *"git clean -f"* ]] && die_block "heuristic: contains 'git clean -f'" "$cmd"
  [[ "$s" == *"git clean -fd"* ]] && die_block "heuristic: contains 'git clean -fd'" "$cmd"
  [[ "$s" == *"git branch -D"* ]] && die_block "heuristic: contains 'git branch -D'" "$cmd"
  [[ "$s" == *"git checkout ."* || "$s" == *"git checkout -- ."* ]] && die_block "heuristic: contains checkout '.'" "$cmd"
  [[ "$s" == *"git restore ."* || "$s" == *"git restore -- ."* ]] && die_block "heuristic: contains restore '.'" "$cmd"

  if p "BLOCK_GIT_PUSH"; then
    [[ "$s" == *"git push"* ]] && die_block "heuristic: contains 'git push'" "$cmd"
  elif p "BLOCK_FORCE_PUSH_ONLY"; then
    [[ "$s" == *"git push"* && ( "$s" == *" --force"* || "$s" == *" -f"* || "$s" == *"--force-with-lease"* ) ]] \
      && die_block "heuristic: contains force push" "$cmd"
  fi
}

INPUT="$(cat)"

payload="$(jq_must "$INPUT" '
  if .tool_input.argv? then
    { mode:"argv", argv:.tool_input.argv }
  else
    { mode:"command", command:.tool_input.command }
  end
')"

mode="$(jq -r '.mode' <<<"$payload")"

if [[ "$mode" == "argv" ]]; then
  mapfile -t argv < <(jq -er '.argv | map(select(type=="string")) | .[]' <<<"$payload")
  ((${#argv[@]} > 0)) || die_block "argv is empty or invalid" "<argv>"
  evaluate_argv "$(printf '%q ' "${argv[@]}")" "${argv[@]}"
  exit 0
fi

p "ACCEPT_STRING_COMMANDS" || die_block "string commands are not accepted; send .tool_input.argv (token array) instead" "<command>"

commands_json="$(jq_must "$payload" '
  .command
  | if type=="string" then [.] 
    elif type=="array" then map(select(type=="string"))
    else error("tool_input.command must be string or array of strings")
    end
')"
mapfile -t commands < <(jq -r '.[]' <<<"$commands_json")

for cmd in "${commands[@]}"; do
  legacy_string_guard "$cmd"
done

exit 0