#!/usr/bin/env bats

# shellcheck source=/dev/null
. tests/base.bats

@test "Fonts chinese" {
  # Skip if running minimal variant (no CJK fonts)
  if docker container run --rm --entrypoint="" "${DOCKER_IMAGE}" dpkg -l fonts-noto-cjk 2>/dev/null | grep -q "^ii"; then
    docker_test "" 0 "export-fonts-chinese" "tests/data" -x -f png fonts/chinese.drawio
    diff tests/expected/fonts-chinese.png tests/data/fonts/chinese.png
  else
    skip "CJK fonts not available (minimal variant)"
  fi
}
