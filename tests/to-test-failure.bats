#!/usr/bin/env bats

@test "This test will always fail" {
  # The run command executes a shell command.
  # We'll use a simple command that outputs "hello".
  run echo "hello"

  # The assert_output command checks if the output matches a specific string.
  # We're asserting that the output is "world", which we know is false.
  # This makes the test fail.
  assert_output "world"

  # We could also use assert_success to check the exit status.
  # In this case, 'echo "hello"' returns 0 (success).
  # We could force a failure by asserting a non-zero exit status, like this:
  # assert_failure
}
