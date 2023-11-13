#!/usr/bin/env bats

docker_test() {
  local docker_opts=$1
  local status=$2
  local output_file=$3
  local data_folder=$4
  shift
  shift
  shift
  shift
  echo docker container run -t $docker_opts -w /data -v $(pwd)/${data_folder:-}:/data ${DOCKER_IMAGE} "$@" >>tests/output/$output_file-command.log
  run docker container run -t $docker_opts -w /data -v $(pwd)/${data_folder:-}:/data ${DOCKER_IMAGE} "$@"

  # Remove timed logging tags on electron logs by default.
  echo "$output" | tee "tests/output/$output_file.log" | sed 's#\[.*:.*/.*\..*:.*:.*\(.*\)\] ##' >"tests/output/$output_file-comp.log"

  [ "$status" -eq $status ]
  if [ -f "tests/expected/$output_file.log" ]; then
    [ "$(diff --strip-trailing-cr "tests/output/$output_file-comp.log" "tests/expected/$output_file.log")" = "" ]
  fi
  if [ -f "tests/expected/uniq-$output_file.log" ]; then
    [ "$(diff --strip-trailing-cr <(sort -u "tests/output/$output_file-comp.log") "tests/expected/uniq-$output_file.log")" = "" ]
  fi
}
