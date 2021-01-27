#!/usr/bin/env bats

docker_test() {
  local status=$1
  local output_file=$2
  local data_folder=$3
  shift
  shift
  shift
  run docker container run -t -e DRAWIO_DESKTOP_COMMAND_TIMEOUT="2s" -w /data -v $(pwd)/${data_folder:-}:/data ${DOCKER_IMAGE} "$@"

  echo "$output" > "tests/output/$output_file.log"

  [ "$status" -eq $status ]
  if [ -f "tests/expected/$output_file.log" ]; then
    [ "$(diff --strip-trailing-cr <(echo "$output") "tests/expected/$output_file.log")" = "" ]
  fi
}
