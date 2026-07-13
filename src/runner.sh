#!/usr/bin/env bash
set -euo pipefail

if [[ "${SCRIPT_DEBUG_MODE:-false}" == "true" ]]; then
  set -x
fi

"${DRAWIO_DESKTOP_EXECUTABLE_PATH:?}" "$@" --no-sandbox --disable-gpu \
  --disable-features=VaapiVideoDecoder,VaapiVideoEncoder \
  --disable-accelerated-video-decode --disable-accelerated-video-encode
