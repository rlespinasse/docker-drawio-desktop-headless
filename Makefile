.PHONY: build run setup-test test cleanup

DOCKER_IMAGE?=rlespinasse/drawio-desktop-headless:local
build:
	@docker build -t ${DOCKER_IMAGE} .

build-no-cache:
	@docker build --no-cache --progress plain -t ${DOCKER_IMAGE} .

RUN_ARGS?=
DOCKER_OPTIONS?=
run:
	@docker run -t $(DOCKER_OPTIONS) -w /data -v $(PWD):/data ${DOCKER_IMAGE} ${RUN_ARGS}

setup-test:
	@npm install bats

test: cleanup build
	@mkdir -p tests/output
	@DOCKER_IMAGE=$(DOCKER_IMAGE) npx bats -r tests

cleanup:
	@rm -rf tests/output
