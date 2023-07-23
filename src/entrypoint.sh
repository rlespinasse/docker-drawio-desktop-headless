#!/usr/bin/env bash
set -euo pipefail

# Prepare output cleaning
touch unwanted-lines.txt
if [[ "${ELECTRON_DISABLE_SECURITY_WARNINGS:?}" == "true" ]]; then
  cat "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-security-warnings.txt" >>"${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
fi

# Start Xvfb
export DISPLAY="${XVFB_DISPLAY:?}"
# shellcheck disable=SC2086
Xvfb "${XVFB_DISPLAY:?}" ${XVFB_OPTIONS:?} &

# Run and filter output
timeout "${DRAWIO_DESKTOP_COMMAND_TIMEOUT:?}" "${DRAWIO_DESKTOP_RUNNER_COMMAND_LINE:?}" "$@" | grep -Fvf "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
