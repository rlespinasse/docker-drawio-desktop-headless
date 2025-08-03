#!/usr/bin/env -S just --justfile

set quiet := true

# Set default architecture based on machine type
arch := if arch() == "aarch64" { "arm64" } else { "amd64" }

# Default docker image name
docker_image := env_var_or_default("DOCKER_IMAGE", "rlespinasse/drawio-desktop-headless:local")

default:
  just --choose

# Build the Docker image for current architecture
[group('Development mode')]
build:
  docker build --build-arg="TARGETARCH={{arch}}" -t {{docker_image}} .

# Build the Docker image without cache
[group('Development mode')]
build-no-cache:
  docker build --build-arg="TARGETARCH={{arch}}" --no-cache --progress plain -t {{docker_image}} .

# Build for multiple architectures
[group('Development mode')]
build-multiarch:
  docker buildx build --platform linux/amd64,linux/arm64 -t {{docker_image}} .

# Clean up test artifacts
[group('Development mode')]
cleanup:
  rm -rf tests/output
  rm -rf tests/data/home
  find tests/data \( -name "*.pdf" -o -name "*.svg" -o -name "*.png" \) -delete

# Run the Docker container
[group('Development mode')]
run *ARGS:
  docker run -t {{env_var_or_default("DOCKER_OPTIONS", "")}} -w /data -v {{invocation_directory()}}:/data {{docker_image}} {{ARGS}}

# Run tests
[group('Testing mode')]
test: cleanup build test-ci

# Setup CI test environment
[group('Testing mode')]
test-ci-setup:
  npm install bats
  sudo apt-get update
  sudo apt-get install -y libxml2-utils

# Run CI tests
[group('Testing mode')]
test-ci:
  mkdir -p tests/output
  DOCKER_IMAGE={{docker_image}} npx bats --verbose-run -r tests

# Auto-update drawio-desktop version
[group('Maintenance mode')]
autoupdate-drawio-desktop:
  #!/usr/bin/env bash
  DRAWIO_DESKTOP_RELEASE=$(gh release list --repo jgraph/drawio-desktop | grep "Latest" | cut -f1)
  sed -i 's/DRAWIO_VERSION=.*/DRAWIO_VERSION="'$DRAWIO_DESKTOP_RELEASE'"/' Dockerfile
  sed -i 's/Draw\.io Desktop v.*/Draw.io Desktop v'$DRAWIO_DESKTOP_RELEASE'\]/' README.adoc
  if [ -n "${GITHUB_OUTPUT}" ]; then
    echo "release_version=$DRAWIO_DESKTOP_RELEASE" >> "${GITHUB_OUTPUT}"
  fi
  echo "Updated to Draw.io Desktop version $DRAWIO_DESKTOP_RELEASE"

[group('Maintenance mode')]
patch: patch-unwanted-security-warnings patch-tests

[private]
patch-unwanted-security-warnings:
  #!/usr/bin/env bash
  cat tests/output/output-electron-security-warning-comp.log | \
    # For now, I remove sqlite_persistent_shared_dictionary_store logs from expected output since this line is inconsistent across runs
    grep -v "sqlite_persistent_shared_dictionary_store" | \
    LC_COLLATE=C sort -u > tests/expected/uniq-output-electron-security-warning.log
  cat tests/output/output-unknown-file-electron-security-warning-comp.log | \
    # For now, I remove sqlite_persistent_shared_dictionary_store logs from expected output since this line is inconsistent across runs
    grep -v "sqlite_persistent_shared_dictionary_store" | \
    LC_COLLATE=C sort -u > tests/expected/uniq-output-unknown-file-electron-security-warning.log

  echo
  {
    awk '{print $1, $2, $3}' tests/output/output-electron-security-warning-comp.log;
    awk '{print $1, $2, $3}' tests/output/output-unknown-file-electron-security-warning-comp.log;
  } | \
  grep -v "file1.drawio" | \
  grep -v "input file/directory" | \
  LC_COLLATE=C sort -u > src/unwanted-security-warnings.txt
  git diff --exit-code src/unwanted-security-warnings.txt || \
    echo "Unwanted Security Warnings have been updated. Please check the changes before committing."
  git diff --exit-code tests/expected/uniq-* || \
    echo "Test files have been updated. Please check the changes before committing."

[private]
patch-tests:
  #!/usr/bin/env bash
  mv tests/data/issue-20/frame-bug-dark.svg tests/expected/issue-20-frame-bug-dark.svg
  mv tests/data/issue-20/frame-bug-light.svg tests/expected/issue-20-frame-bug-light.svg
  mv tests/data/fonts/chinese.png tests/expected/fonts-chinese.png
  git diff --exit-code tests/expected || \
    echo "Test files have been updated. Please check the changes before committing."
