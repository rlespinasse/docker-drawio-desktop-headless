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
