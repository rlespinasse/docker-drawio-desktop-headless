#!/usr/bin/env bats

. tests/base.bats

@test "Fonts chinese" {
  docker_test "" 0 "export-fonts-chinese" "tests/data" -x -f png fonts/chinese.drawio
  diff tests/expected/fonts-chinese.png tests/data/fonts/chinese.png
}
