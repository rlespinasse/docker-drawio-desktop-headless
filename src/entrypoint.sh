#!/usr/bin/env bash
set -euo pipefail

if [[ "${SCRIPT_DEBUG_MODE:-false}" == "true" ]]; then
  set -x
fi

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

# Start D-Bus buses
# Electron probes both (Bluetooth/NameHasOwner/accessibility) even though they're unused
# in a headless export. Best-effort: skip silently if we lack permission (e.g. non-root user).
if mkdir -p /run/dbus 2>/dev/null; then
  dbus-uuidgen --ensure >/dev/null 2>&1 || true
  dbus-daemon --system --fork >/dev/null 2>&1 || true
fi
eval "$(dbus-launch --sh-syntax 2>/dev/null)" 2>/dev/null || true

# Start Xvfb
export DISPLAY="${XVFB_DISPLAY:?}"
# shellcheck disable=SC2086
# shellcheck disable=SC2154
Xvfb "${XVFB_DISPLAY:?}" ${XVFB_OPTIONS} &

# Run

timeout "${DRAWIO_DESKTOP_COMMAND_TIMEOUT:?}" "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/runner_wrapper.sh" "$@"
