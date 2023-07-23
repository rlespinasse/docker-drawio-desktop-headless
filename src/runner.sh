#!/usr/bin/env bash
set -euo pipefail

"${DRAWIO_DESKTOP_EXECUTABLE_PATH:?}" "$@" --no-sandbox 2>&1
