#!/usr/bin/env bash
set -euo pipefail

# Run and filter output
"${DRAWIO_DESKTOP_RUNNER_COMMAND_LINE:?}" "$@" 2>&1 | grep -Fvf "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
