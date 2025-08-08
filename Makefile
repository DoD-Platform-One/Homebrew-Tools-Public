#!/usr/bin/env bash

##########################################################################
#
# make tasks for homebrew-tools-public
#
# note: we only have the one formula now, we'll need to extend this
# once we grow beyond just `bbctl`
#
##########################################################################

TAP_NAME := bigbang/tools-public
FORMULA_NAME := bbctl

LINUX_DOCKER_PLATFORM := linux/amd64
LINUX_DOCKER_IMAGE := linuxbrew/test:dev

GITCONFIG_PATH := ~/.gitconfig

.PHONY: default help brew brew-uninstall brew-install brew-lint brew-test

default: help

help:
	cat Makefile

brew: brew-uninstall brew-install brew-lint brew-test

brew-uninstall:
	brew uninstall -f "$(FORMULA_NAME)"
	brew untap -f "$(TAP_NAME)" || echo "untap complete, swallowing return code..."


brew-tap:
	brew tap "$(TAP_NAME)" .
	brew update

brew-install: brew-uninstall brew-tap
	brew reinstall -f "$(TAP_NAME)/$(FORMULA_NAME)"

brew-lint:
	brew audit --verbose --strict --formula "$(TAP_NAME)/$(FORMULA_NAME)"

brew-test:
	brew test --verbose --debug "$(TAP_NAME)/$(FORMULA_NAME)"

lint:
	markdownlint --disable=MD013 ./**/*md
	git ls-files | grep -E "(Makefile|\.sh)" | xargs -n1 shellcheck

linuxbrew-build:
	docker build --progress=plain --platform="$(LINUX_DOCKER_PLATFORM)" . -t "$(LINUX_DOCKER_IMAGE)"

linuxbrew-test:
	docker run --platform="$(LINUX_DOCKER_PLATFORM)" --entrypoint=/bin/bash -ti -v "$(GITCONFIG_PATH):/etc/gitconfig" "$(LINUX_DOCKER_IMAGE)" "./scripts/install-and-test-each-formula.sh"

linuxbrew-shell:
	docker run --platform="$(LINUX_DOCKER_PLATFORM)" --entrypoint=/bin/bash -ti -v "$(GITCONFIG_PATH):/etc/gitconfig" "$(LINUX_DOCKER_IMAGE)"
