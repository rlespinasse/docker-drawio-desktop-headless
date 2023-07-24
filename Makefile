.PHONY: build build-no-cache build-multiarch cleanup run test test-ci-setup test-ci

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
	@rm -rf tests/data/*.pdf
	@rm -rf tests/data/**/*.pdf
	@rm -rf tests/data/*.svg
	@rm -rf tests/data/**/*.svg
	@rm -rf tests/data/*.png
	@rm -rf tests/data/**/*.png

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
