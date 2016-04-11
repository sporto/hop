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

### TEST LOCALLY

# Run unit tests locally
test-unit:
	cd ./test/unit && npm test

### TESTS IN DOCKER

# Run unit test in docker
test-unit-docker:
	docker-compose up test_unit

# Run basic app test inside a docker container
# Run integration tests
test-basic-int-docker:
	docker-compose up test_example_basic

test-full-int-docker:
	docker-compose up test_example_full

.PHONY: docs test
