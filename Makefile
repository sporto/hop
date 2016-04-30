# Start basic application example locally
basic-up:
	cd ./examples/basic && elm reactor

full-up:
	cd ./examples/full && npm run dev

test-up:
	cd ./examples/test && npm run dev

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
	
# Run integration test locally
# You need to have a webdriver and app running for this e.g.
# - make test-up
# - selenium-server -p 4444
# - phantomjs --wd
test-int:
	cd ./test/integration && APP_HOST=localhost APP_PORT=9000 ROUTER_HASH=0 WEBDRIVER_DRIVER=phantomjs mix test

### TESTS IN DOCKER

# Run unit test
test-unit-docker:
	docker-compose run --rm test_unit
	docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '

# Test building basic app
test-basic-build-docker:
	docker-compose run --rm example_basic
	docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '

# Test building full app
test-full-build-docker:
	docker-compose run --rm example_full
	docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '

# Run integration tests
test-int-docker:
	docker-compose run --rm --service-ports test_app_integration
	docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '

upgrade-deps:
	cd ./support/upgrade_deps && mix escript.build
	./support/upgrade_deps/upgrade_deps --dir ${PWD}
	./support/upgrade_deps/upgrade_deps --dir ${PWD}/test/unit
	./support/upgrade_deps/upgrade_deps --dir ${PWD}/examples/basic
	./support/upgrade_deps/upgrade_deps --dir ${PWD}/examples/full

.PHONY: docs test
