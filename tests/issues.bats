#!/usr/bin/env bats

# shellcheck source=/dev/null
. tests/base.bats

@test "Issue 20 : frame bug / svg :: theme=light" {
  docker_test "" 0 "export-issue-20-light" "tests/data" -x -f svg issue-20/frame-bug-light.drawio --svg-theme light
  diff <(xmllint --format tests/expected/issue-20-frame-bug-light.svg) <(xmllint --format tests/data/issue-20/frame-bug-light.svg)
}

@test "Issue 20 : frame bug / svg :: theme=dark" {
  docker_test "" 0 "export-issue-20-dark" "tests/data" -x -f svg issue-20/frame-bug-dark.drawio --svg-theme dark
  diff <(xmllint --format tests/expected/issue-20-frame-bug-dark.svg) <(xmllint --format tests/data/issue-20/frame-bug-dark.svg)
}
