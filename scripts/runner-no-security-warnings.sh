#!/usr/bin/env bash
set -e

"$DRAWIO_DESKTOP_EXECUTABLE_PATH" "$@" --no-sandbox 2>&1
