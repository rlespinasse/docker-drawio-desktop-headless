#!/usr/bin/env bats

. tests/base.bats

@test "Export a drawio file as pdf" {
  docker_test "" 0 "export-file1" "tests/data" -x file1.drawio
}

@test "Export a drawio file with space in its name" {
  docker_test "" 0 "export-file2" "tests/data" -x "file 2.drawio"
}

@test "Export with check command" {
  docker_test "" 1 "export-check-firstrun" "tests/data" -export --check file3.drawio
  docker_test "" 1 "export-check-secondrun" "tests/data" -export --check file3.drawio
  docker_test "" 1 "export-check-thirdrun" "tests/data" -export file3.drawio
}

@test "Export using unknown argument" {
  docker_test "" 0 "export-file1" "tests/data" --export file1.drawio --wrong-argument
}
