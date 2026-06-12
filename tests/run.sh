#!/usr/bin/env bash
# Pretty runner for all docs checks — called by `make test` (repo root).
# BuildKit-style output: while a check runs, only a live tail of its last few
# output lines is shown; on success it collapses to a single ✔ line, on
# failure the full log is printed. Runs every check even if one fails and
# prints a summary at the end. Without a TTY (CI, pipes) it falls back to
# plain full output.
set -u

cd "$(dirname "$0")/.."

TTY=0
if [ -t 1 ]; then
  TTY=1
  BOLD=$'\e[1m'; DIM=$'\e[2m'; RED=$'\e[31m'; GREEN=$'\e[32m'; CYAN=$'\e[36m'; RESET=$'\e[0m'
else
  BOLD=''; DIM=''; RED=''; GREEN=''; CYAN=''; RESET=''
fi

WIDTH=64    # width of the boxes/rules
WINDOW=10   # number of live tail lines per running check

# sed instead of tr: tr works on bytes and mangles the multi-byte ─ character
line() { printf '%*s' "$WIDTH" '' | sed "s/ /$1/g"; }
box()  { # box <text>
  printf '\n  %s┌%s┐%s\n' "$DIM" "$(line ─)" "$RESET"
  printf '  %s│%s %s%-*s%s%s│%s\n' "$DIM" "$RESET" "$BOLD" $((WIDTH - 2)) "$1" "$RESET" "$DIM" "$RESET"
  printf '  %s└%s┘%s\n\n' "$DIM" "$(line ─)" "$RESET"
}

# Normalize tool output for the live window: turn carriage returns (progress
# bars) into newlines and strip ANSI escape sequences, unbuffered so the
# window updates in real time.
strip_ctrl() {
  stdbuf -oL tr '\r' '\n' \
    | stdbuf -oL sed -E $'s/\e\\[[0-9;?]*[a-zA-Z]//g; s/\e\\][^\a]*\a?//g'
}

# Rolling tail of the last $1 lines, redrawn in place via cursor movement and
# fully cleared when the input ends (the "collapse").
window() {
  local max=$1 drawn=0 cols i l
  cols=$(( $(tput cols 2>/dev/null || echo 80) - 8 ))
  local -a buf=()
  while IFS= read -r l; do
    [ -n "${l//[[:space:]]/}" ] || continue
    buf+=("${l:0:cols}")
    if (( ${#buf[@]} > max )); then buf=("${buf[@]:1}"); fi
    (( drawn )) && printf '\e[%dA' "$drawn"
    for (( i = 0; i < ${#buf[@]}; i++ )); do
      printf '\e[2K      %s%s%s\n' "$DIM" "${buf[i]}" "$RESET"
    done
    drawn=${#buf[@]}
  done
  (( drawn )) && printf '\e[%dA\e[0J' "$drawn"
}

# run_check <target> <logfile> — run a make target, windowed on a TTY.
run_check() {
  local target=$1 log=$2
  if (( TTY )); then
    make -s "$target" 2>&1 | tee "$log" | strip_ctrl | window "$WINDOW"
  else
    make -s "$target" 2>&1 | tee "$log"
  fi
  return "${PIPESTATUS[0]}"
}

CHECKS=(
  "lint|Markdown Lint    (markdownlint-cli2)"
  "build|Build Check      (zensical build --strict)"
  "links|Dead Link Check  (lychee)"
)

NAMES=(); RESULTS=(); TIMES=()
TOTAL=${#CHECKS[@]}; FAILED=0; START=$SECONDS
LOG=$(mktemp); trap 'rm -f "$LOG"' EXIT

printf '\n  %s(Run Starting)%s\n' "$BOLD$CYAN" "$RESET"
box "Wavelog Docs · $TOTAL checks: lint, build, links"

i=0
for entry in "${CHECKS[@]}"; do
  target=${entry%%|*}; label=${entry#*|}
  i=$((i + 1))

  printf '  %s▶%s [%d/%d] %s\n' "$CYAN" "$RESET" "$i" "$TOTAL" "$label"

  t0=$SECONDS
  if run_check "$target" "$LOG"; then
    result=pass
    # rewrite the ▶ header line in place as a collapsed ✔ line
    (( TTY )) && printf '\e[1A\e[2K'
    printf '  %s✔%s [%d/%d] %s %s(%ss)%s\n' \
      "$GREEN" "$RESET" "$i" "$TOTAL" "$label" "$DIM" "$((SECONDS - t0))" "$RESET"
  else
    result=fail
    FAILED=$((FAILED + 1))
    (( TTY )) && printf '\e[1A\e[2K'
    printf '  %s✖%s [%d/%d] %s %s(%ss)%s\n\n' \
      "$RED" "$RESET" "$i" "$TOTAL" "$label" "$DIM" "$((SECONDS - t0))" "$RESET"
    # on failure, show the full log (colors kept, progress junk normalized)
    tr '\r' '\n' < "$LOG" | sed 's/^/      /'
    printf '\n'
  fi
  NAMES+=("$target"); RESULTS+=("$result"); TIMES+=($((SECONDS - t0)))
done

printf '\n  %s(Run Finished)%s\n' "$BOLD$CYAN" "$RESET"
printf '\n  %s%s%s\n' "$DIM" "$(line ─)" "$RESET"
for idx in "${!NAMES[@]}"; do
  if [ "${RESULTS[$idx]}" = pass ]; then
    printf '  %s✔%s  %-10s %s%3ss%s   %spassed%s\n' \
      "$GREEN" "$RESET" "${NAMES[$idx]}" "$DIM" "${TIMES[$idx]}" "$RESET" "$GREEN" "$RESET"
  else
    printf '  %s✖%s  %-10s %s%3ss%s   %sfailed%s\n' \
      "$RED" "$RESET" "${NAMES[$idx]}" "$DIM" "${TIMES[$idx]}" "$RESET" "$RED" "$RESET"
  fi
done
printf '  %s%s%s\n' "$DIM" "$(line ─)" "$RESET"

if [ "$FAILED" -eq 0 ]; then
  printf '  %s✔ All %d checks passed%s %s(%ss)%s - ready to push!\n\n' \
    "$BOLD$GREEN" "$TOTAL" "$RESET" "$DIM" "$((SECONDS - START))" "$RESET"
else
  printf '  %s✖ %d of %d checks failed%s %s(%ss)%s\n\n' \
    "$BOLD$RED" "$FAILED" "$TOTAL" "$RESET" "$DIM" "$((SECONDS - START))" "$RESET"
  exit 1
fi
