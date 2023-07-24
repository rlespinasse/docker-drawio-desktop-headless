#!/usr/bin/env bash
set -euo pipefail

# Prepare output cleaning
touch "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
if [[ "${ELECTRON_DISABLE_SECURITY_WARNINGS:?}" == "true" ]]; then
  cat "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-security-warnings.txt" >>"${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
fi

if [[ "${DRAWIO_DISABLE_UPDATE:?}" == "true" ]]; then
  # Remove 'deb support' logs
  # since 'autoUpdater.logger.transports.file.level' is set as 'info' on drawio-desktop
  cat "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-update-logs.txt" >>"${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
fi

# Start Xvfb
export DISPLAY="${XVFB_DISPLAY:?}"
# shellcheck disable=SC2086
# shellcheck disable=SC2154
Xvfb "${XVFB_DISPLAY:?}" ${XVFB_OPTIONS} &

# Run
timeout "${DRAWIO_DESKTOP_COMMAND_TIMEOUT:?}" "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/runner_wrapper.sh" "$@"
