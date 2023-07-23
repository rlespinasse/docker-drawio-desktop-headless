#!/usr/bin/env bash
set -euo pipefail

# Prepare output cleaning
touch unwanted-lines.txt
if [[ "${ELECTRON_DISABLE_SECURITY_WARNINGS:?}" == "true" ]]; then
  cat unwanted-security-warnings.txt >>unwanted-lines.txt
fi

# Start Xvfb
export DISPLAY="${XVFB_DISPLAY:?}"
# shellcheck disable=SC2086
Xvfb "${XVFB_DISPLAY:?}" ${XVFB_OPTIONS:?} &

# Run and filter output
timeout "${DRAWIO_DESKTOP_COMMAND_TIMEOUT:?}" "${DRAWIO_DESKTOP_RUNNER_COMMAND_LINE:?}" "$@" | grep -Fvf unwanted-lines.txt
