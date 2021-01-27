#!/usr/bin/env bash
set -e

if [ "${ELECTRON_DISABLE_SECURITY_WARNINGS}" == "true" ]; then
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox 2>/dev/null
else
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox
fi
