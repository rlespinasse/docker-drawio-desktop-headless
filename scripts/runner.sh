#!/usr/bin/env bash
set -e

filter_electron_security_warnings() {
  while read -r line; do
    echo "$line" | grep -v "The default of contextIsolation is deprecated"
  done
}

if [ "${ELECTRON_DISABLE_SECURITY_WARNINGS}" == "true" ]; then
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox 2> >(filter_electron_security_warnings)
else
  "$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox
fi
