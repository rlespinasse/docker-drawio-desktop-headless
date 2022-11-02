#!/usr/bin/env bash
set -e

if [ "${ELECTRON_DISABLE_SECURITY_WARNINGS}" == "true" ]; then
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox 2> >(grep -v "Failed to connect to socket\|Could not parse server address\|Floss manager not present\|Exiting GPU process\|called with multiple threads\|extension not supported\|Failed to send GpuControl.CreateCommandBuffer")
else
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox 2>&1
fi
