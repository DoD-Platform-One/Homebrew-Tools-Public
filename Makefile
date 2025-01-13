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

.PHONY: default help brew brew-uninstall brew-install brew-lint brew-test

default: help

help:
	cat Makefile

brew: brew-uninstall brew-install brew-lint brew-test

brew-uninstall:
	brew uninstall -f "$(FORMULA_NAME)"
	brew untap -f "$(TAP_NAME)" || echo "untap complete, swallowing return code..."

brew-install: brew-uninstall
	brew tap "$(TAP_NAME)" .
	brew reinstall -f "$(TAP_NAME)/$(FORMULA_NAME)"

brew-lint:
	brew audit --verbose --strict --formula "$(TAP_NAME)/$(FORMULA_NAME)"

brew-test:
	brew test --verbose --debug "$(TAP_NAME)/$(FORMULA_NAME)"

lint:
	markdownlint --disable=MD013 ./**/*md
	git ls-files | grep -E "(Makefile|\.sh)" | xargs -n1 shellcheck

linuxbrew-test:
	docker build --platform="$(LINUX_DOCKER_PLATFORM)" . -t "$(LINUX_DOCKER_IMAGE)"

linuxbrew-shell: linuxbrew-test
	docker run --platform="$(LINUX_DOCKER_PLATFORM)" --entrypoint=/bin/bash -ti "$(LINUX_DOCKER_IMAGE)"