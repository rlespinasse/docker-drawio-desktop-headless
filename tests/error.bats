#!/usr/bin/env bats

# shellcheck source=/dev/null
. tests/base.bats

@test "Output an error on unknown file" {
  docker_test "" 1 "output-unknown-file" "tests/data" -x unknown.drawio
}

@test "Output an error on unknown file with electron security warning" {
  if [[ $(uname) == "Darwin" ]]; then
    skip "Skipping test on macOS"
  fi
  docker_test "-e ELECTRON_DISABLE_SECURITY_WARNINGS=false" 0 "output-unknown-file-electron-security-warning" "tests/data" -x unknown.drawio
}
