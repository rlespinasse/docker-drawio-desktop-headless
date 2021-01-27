.PHONY: build run setup-test test cleanup

DOCKER_IMAGE?=rlespinasse/drawio-desktop-headless:local
build:
	@docker build -t ${DOCKER_IMAGE} .

RUN_ARGS?=
DOCKER_OPTIONS?=
run:
	@docker run -t $(DOCKER_OPTIONS) -w /data -v $(PWD):/data ${DOCKER_IMAGE} ${RUN_ARGS}

setup-test:
	@npm install -g bats

test: cleanup build
	@mkdir -p tests/output
	@DOCKER_IMAGE=$(DOCKER_IMAGE) bats -r tests

cleanup:
	@rm -rf tests/output
