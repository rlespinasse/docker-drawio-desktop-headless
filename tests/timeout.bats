#!/usr/bin/env bats

. tests/base.bats

@test "Timeout for using create command" {
  docker_test "-e DRAWIO_DESKTOP_COMMAND_TIMEOUT=2s" 1 "output-create-command" "tests" --create output/empty.drawio
}

@test "Timeout for using check command" {
  docker_test "-e DRAWIO_DESKTOP_COMMAND_TIMEOUT=2s" 1 "output-check-command" "tests" --check output/empty.drawio
}

@test "Timeout for using wrong command" {
  docker_test "-e DRAWIO_DESKTOP_COMMAND_TIMEOUT=2s" 1 "output-wrong-command" "tests/data" --wrong-command
}
