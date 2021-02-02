#!/usr/bin/env bats

. tests/base.bats

@test "Timeout for using create command" {
  docker_test "-e DRAWIO_DESKTOP_COMMAND_TIMEOUT=2s" 1 "no_output" "tests" --create output/empty.drawio
}

@test "Timeout for using check command" {
  docker_test "-e DRAWIO_DESKTOP_COMMAND_TIMEOUT=2s" 1 "no_output" "tests" --check output/empty.drawio
}

@test "Timeout for using wrong command" {
  docker_test "-e DRAWIO_DESKTOP_COMMAND_TIMEOUT=2s" 1 "no_output" "tests/data" --wrong-command
}
