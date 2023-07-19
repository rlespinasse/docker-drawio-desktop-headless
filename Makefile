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

setup-test-on-ci:
	@npm install bats
	@sudo apt-get install -y libxml2-utils

test: cleanup build
	@mkdir -p tests/output
	@DOCKER_IMAGE=$(DOCKER_IMAGE) npx bats -r tests

test-on-ci:
	@mkdir -p tests/output
	@DOCKER_IMAGE=$(DOCKER_IMAGE) npx bats -r tests

cleanup:
	@rm -rf tests/output
	@rm -rf tests/data/*.pdf
	@rm -rf tests/data/**/*.pdf
	@rm -rf tests/data/*.svg
	@rm -rf tests/data/**/*.svg
	@rm -rf tests/data/*.png
	@rm -rf tests/data/**/*.png
