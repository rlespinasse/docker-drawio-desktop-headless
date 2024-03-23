.PHONY: build build-no-cache build-multiarch cleanup run test test-ci-setup test-ci autoupdate-drawio-desktop

# amd64 by default, arm64 for arm machine like macbook m1
ifneq ($(filter arm%,$(shell uname -p)),)
ARCHFLAG := "arm64"
else
ARCHFLAG := "amd64"
endif

DOCKER_IMAGE?=rlespinasse/drawio-desktop-headless:local
build:
	@docker build --build-arg="TARGETARCH=$(ARCHFLAG)" -t ${DOCKER_IMAGE} .

build-no-cache:
	@docker build --build-arg="TARGETARCH=$(ARCHFLAG)" --no-cache --progress plain -t ${DOCKER_IMAGE} .

build-multiarch:
	@docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKER_IMAGE} .

cleanup:
	@rm -rf tests/output
	@rm -rf tests/data/home
	@find tests/data \( -name "*.pdf" -o -name "*.svg" -o -name "*.png" \) -delete

RUN_ARGS?=
DOCKER_OPTIONS?=
run:
	@docker run -t $(DOCKER_OPTIONS) -w /data -v $(PWD):/data ${DOCKER_IMAGE} ${RUN_ARGS}

test: cleanup build test-ci

test-ci-setup:
	@npm install bats
	@sudo apt-get install -y libxml2-utils

test-ci:
	@mkdir -p tests/output
	@DOCKER_IMAGE=$(DOCKER_IMAGE) npx bats -r tests

autoupdate-drawio-desktop:
	@$(eval DRAWIO_DESKTOP_RELEASE := $(shell gh release list --repo jgraph/drawio-desktop | grep "Latest" | cut -f1))
	@sed -i 's/DRAWIO_VERSION=.*/DRAWIO_VERSION="$(DRAWIO_DESKTOP_RELEASE)"/' Dockerfile
	@sed -i 's/Draw\.io Desktop v.*/Draw.io Desktop v$(DRAWIO_DESKTOP_RELEASE)\]/' README.adoc
	@test -z "${GITHUB_OUTPUT}" || echo "release_version=$(DRAWIO_DESKTOP_RELEASE)" >> "${GITHUB_OUTPUT}"
