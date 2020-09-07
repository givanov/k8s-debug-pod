GIT_SHORT_COMMIT := $(shell git rev-parse --short HEAD)
GIT_TAG    := $(shell git describe --tags --abbrev=0 --exact-match 2>/dev/null)

TMP_VERSION := $(GIT_SHORT_COMMIT)

ifndef VERSION
ifeq ($(GIT_DIRTY), clean)
ifdef GIT_TAG
	TMP_VERSION = $(GIT_TAG)
endif
endif
endif

VERSION ?= $(TMP_VERSION)

.PHONY: export-tag-github-actions
export-tag-github-actions:
	@echo ::set-output name=output_msg::$(VERSION)

.PHONY: semantic-release
semantic-release:
	@npm ci
	@npx semantic-release

.PHONY: semantic-release-dry-run
semantic-release-dry-run:
	@npm ci
	@npx semantic-release -d

package-lock.json: package.json
	@npm install

.PHONY: install-npm-check-updates
install-npm-check-updates:
	npm install npm-check-updates

.PHONY: update-npm-dependencies
update-npm-dependencies: install-npm-check-updates
	ncu -u
	npm install

DOCKER_REPO := quay.io/givanov
DOCKER_IMAGE_NAME := debug
DOCKER_PLATFORMS ?= linux/arm,linux/arm64,linux/amd64
DOCKER_IMAGE_TAG ?= $(VERSION)
DOCKERFILE_PATH = Dockerfile
DOCKERBUILD_CONTEXT = .

.PHONY: docker-image-build-push
docker-image-build-push:
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -f $(DOCKERFILE_PATH) -t $(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) --platform=$(DOCKER_PLATFORMS) . --push