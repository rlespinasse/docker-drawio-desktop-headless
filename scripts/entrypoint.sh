#!/usr/bin/env bash
set -e

# Start Xvfb
export DISPLAY="${XVFB_DISPLAY}"
# shellcheck disable=SC2086
Xvfb "${XVFB_DISPLAY}" ${XVFB_OPTIONS} &

# shellcheck disable=SC2068
timeout "${DRAWIO_DESKTOP_COMMAND_TIMEOUT}" "${DRAWIO_DESKTOP_RUNNER_COMMAND_LINE}" "$@"
