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
	docker-compose run --rm test_unit
	docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '

# Run basic app test inside a docker container
# Run integration tests
test-basic-int-docker:
	docker-compose run --rm --service-ports test_example_basic
	docker-compose stop
	docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '

test-full-int-docker:
	docker-compose run --rm --service-ports test_example_full
	docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '

upgrade-deps:
	cd ./support/upgrade_deps && mix escript.build
	./support/upgrade_deps/upgrade_deps --dir ${PWD}
	./support/upgrade_deps/upgrade_deps --dir ${PWD}/test/unit
	./support/upgrade_deps/upgrade_deps --dir ${PWD}/examples/basic
	./support/upgrade_deps/upgrade_deps --dir ${PWD}/examples/full

.PHONY: docs test
