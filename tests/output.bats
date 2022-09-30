#!/usr/bin/env bats

. tests/base.bats

@test "Output an error on unknown file" {
  docker_test "" 1 "output-unknown-file" "tests/data" -x unknown.drawio
}

#@test "Output electron security warning" {
#  docker_test "-e ELECTRON_DISABLE_SECURITY_WARNINGS=false" 0 "output-electron-security-warning" "tests/data" -x file1.drawio
#}
