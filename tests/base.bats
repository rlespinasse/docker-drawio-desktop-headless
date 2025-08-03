#!/usr/bin/env bats

docker_test() {
  # Get parameters
  local docker_opts=$1
  local status=$2
  local output_file=$3
  local data_folder=$4
  shift
  shift
  shift
  shift

  # Run command
  # shellcheck disable=SC2086
  echo docker container run -t $docker_opts -w /data -v "$(pwd)/${data_folder:-}":/data ${DOCKER_IMAGE} "$@" >>tests/output/$output_file-command.log
  # shellcheck disable=SC2086
  run docker container run -t $docker_opts -w /data -v "$(pwd)/${data_folder:-}":/data ${DOCKER_IMAGE} "$@"

  # Remove timed logging tags on electron logs by default.
  # shellcheck disable=SC2154
  echo "$output" | tee "tests/output/$output_file.log" | sed 's#\[.*:.*/.*\..*:.*:.*\(.*\)\] ##' >"tests/output/$output_file-comp.log"

  # Test status
  # shellcheck disable=SC2086
  [ "$status" -eq $status ]
  # Test output
  if [ -f "tests/expected/$output_file.log" ]; then
    diff -u --strip-trailing-cr "tests/expected/$output_file.log" "tests/output/$output_file-comp.log" >"tests/output/$output_file-diff.log"
  elif [ -f "tests/expected/uniq-$output_file.log" ]; then
    # For now, I remove sqlite_persistent_shared_dictionary_store logs from expected output since this line is inconsistent across runs
    diff -u --strip-trailing-cr "tests/expected/uniq-$output_file.log" <(LC_COLLATE=C sort -u "tests/output/$output_file-comp.log" | grep -v "sqlite_persistent_shared_dictionary_store") >"tests/output/$output_file-diff.log"
  fi
  if [ -f "tests/output/$output_file-diff.log" ]; then
    [ "$(cat "tests/output/$output_file-diff.log")" = "" ]
  fi
}
