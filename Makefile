SHELL := /bin/bash

.PHONY: deps init

deps:
	./scripts/install_deps.sh

init: deps
	DIR="$(DIR)" ./scripts/init.sh
