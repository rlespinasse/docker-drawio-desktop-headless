#!/usr/bin/env bats

# shellcheck source=/dev/null
. tests/base.bats

@test "Issue 20 : frame bug / svg :: theme=light" {
  docker_test "" 0 "export-issue-20-light" "tests/data" -x -f svg issue-20/frame-bug-light.drawio --svg-theme light
  diff <(xmllint --format tests/expected/issue-20-frame-bug-light.svg | sed 's/ id="ge-svg-[^"]*"//; s/#ge-svg-[a-zA-Z0-9_-]*/dummy-id/g') <(xmllint --format tests/data/issue-20/frame-bug-light.svg | sed 's/ id="ge-svg-[^"]*"//; s/#ge-svg-[a-zA-Z0-9_-]*/dummy-id/g')
}

@test "Issue 20 : frame bug / svg :: theme=dark" {
  docker_test "" 0 "export-issue-20-dark" "tests/data" -x -f svg issue-20/frame-bug-dark.drawio --svg-theme dark
  diff <(xmllint --format tests/expected/issue-20-frame-bug-dark.svg | sed 's/ id="ge-svg-[^"]*"//; s/#ge-svg-[a-zA-Z0-9_-]*/dummy-id/g') <(xmllint --format tests/data/issue-20/frame-bug-dark.svg | sed 's/ id="ge-svg-[^"]*"//; s/#ge-svg-[a-zA-Z0-9_-]*/dummy-id/g')
}

@test "Issue 84 : helvetica font on png creation" {
  docker_test "" 0 "export-issue-84-helvetica" "tests/data" -x -f png issue-84/helvetica.drawio
  diff tests/expected/issue-84-helvetica.png tests/data/issue-84/helvetica.png
}
