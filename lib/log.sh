#!/bin/bash

# Record global execution start time
log_start() {
  echo ">>> arch-be-good start: $(date '+%F %T')" >>"$ABG_LOG"
}

# Record global execution termination time
log_end() {
  echo ">>> done: $(date '+%F %T')" >>"$ABG_LOG"
  echo "  arch-be-good: done ($ABG_LOG)"
}

# Wrapper to execute sub-scripts in an isolated subshell with strict log capturing
run_logged() {
  local script="$1"
  local name="${script#"$ABG_PATH"/}"

  echo ":: $name"
  echo "[$(date '+%F %T')] start: $name" >>"$ABG_LOG"

  # Execute in a clean environment; isolate stdin and capture both stdout/stderr
  if bash -c "source '$script'" </dev/null >>"$ABG_LOG" 2>&1; then
    echo "[$(date '+%F %T')] ok: $name" >>"$ABG_LOG"
    echo "  ok"
  else
    local code=$?
    echo "[$(date '+%F %T')] FAILED ($code): $name" >>"$ABG_LOG"
    echo "  failed - see $ABG_LOG (tail)"
    # Print tailing failure context to stderr
    tail -n 15 "$ABG_LOG" | sed 's/^/   | /'
    exit $code
  fi
}
