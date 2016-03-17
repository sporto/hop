test-up:
	cd ./src/Test && elm reactor

basic-up:
	cd ./examples/basic && elm reactor

full-up:
	cd ./examples/full && elm reactor

flow:
	java -jar /usr/local/bin/plantuml.jar -ttxt assets/flow.pu

docs:
	elm make --docs=documentation.json

test-lib:
	cd ./test && npm test

test-basic:
	cd ./examples/basic && elm make Main.elm

test-full:
	cd ./examples/full && elm make Main.elm

ci-prepare:
	node --version
	npm --version
	npm install -g elm

	@echo "============================"
	@echo "Installing deps for test"
	cd ./test && npm install
	cd ./test && elm package install -y

	@echo "============================"
	@echo "Installing deps for basic app"
	cd ./examples/basic && elm package install -y

	@echo "============================"
	@echo "Installing deps for full app"
	cd ./examples/full && elm package install -y

test:
	make test-lib
	make test-basic
	make test-full

.PHONY: docs test
