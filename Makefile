# Start basic application example locally
basic-up:
	cd ./examples/basic && elm reactor

full-up:
	cd ./examples/full && npm run dev

# Generate diagramas using PlantUML
flow:
	java -jar /usr/local/bin/plantuml.jar -ttxt assets/flow.pu

# Generate documentation for preview
docs:
	elm make --docs=documentation.json

# Run unit tests locally
test-unit:
	cd ./test/unit && npm test

# Run unit test in docker
test-unit-doc:
	docker-compose up test_unit

# Test that basic app builds
test-basic-build:
	cd ./examples/basic && elm make Main.elm

# Test that full app builds
test-full-build:
	cd ./examples/full && elm make src/Main.elm && rm index.html

# Run basic app test inside a docker container
# Run integration tests
test-basic-int:
	docker-compose up test_example_basic

# example-basic-sh:
# 	docker-compose run example-basic /bin/bash

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
	make test-basic-build
	make test-full-build

.PHONY: docs test
