#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Core execution directory relative to this script's location
export ABG_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Log lives in XDG state: bootstrap runs as a normal user, so the log
# should be user-owned too - no sudo needed to write it, and it survives repo removal.
export ABG_LOG="${XDG_STATE_HOME:-$HOME/.local/state}/arch-be-good/install.log"
mkdir -p "$(dirname "$ABG_LOG")"
# Expose local project binaries to the current environment PATH
export PATH="$ABG_PATH/bin:$PATH"

# Modules & Initialization
source "$ABG_PATH/lib/log.sh"
source "$ABG_PATH/preflight/guard.sh"

# Pipeline
log_start
run_logged "$ABG_PATH/preflight/pacman.sh"
log_end
