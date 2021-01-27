#!/usr/bin/env bats

. tests/base.bats

@test "Print help" {
  docker_test 0 "print_help" "tests/data" --help
}

@test "Print help using short option" {
  docker_test 0 "print_help" "tests/data" -h
}
