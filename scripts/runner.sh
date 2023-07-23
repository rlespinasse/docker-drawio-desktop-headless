#!/usr/bin/env bash
set -euo pipefail

if [ "${ELECTRON_DISABLE_SECURITY_WARNINGS}" == "true" ]; then
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox 2>&1 |
    grep -v "Failed to connect to socket" |
    grep -v "Could not parse server address" |
    grep -v "Floss manager not present" |
    grep -v "Exiting GPU process" |
    grep -v "called with multiple threads" |
    grep -v "extension not supported" |
    grep -v "Failed to send GpuControl.CreateCommandBuffer" |
    grep -v "Init observer found at shutdown" |
    # Remove 'deb support' logs
    # since 'autoUpdater.logger.transports.file.level' is set as 'info' on drawio-desktop
    grep -v "Checking for beta autoupdate feature for deb/rpm distributions" |
    grep -v "Found package-type:deb"
else
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox 2>&1 |
    # Remove 'deb support' logs
    # since 'autoUpdater.logger.transports.file.level' is set as 'info' on drawio-desktop
    grep -v "Checking for beta autoupdate feature for deb/rpm distributions" |
    grep -v "Found package-type:deb"
fi
