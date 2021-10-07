#!/usr/bin/env bats

. tests/base.bats

@test "Issue 20 - frame bug / svg" {
  docker_test "" 0 "export-issue-20" "tests/data" -x -f svg issue-20/frame-bug.drawio
  diff <(xmllint --format tests/data/issue-20/frame-bug-good.svg) <(xmllint --format tests/data/issue-20/frame-bug.svg)
}
