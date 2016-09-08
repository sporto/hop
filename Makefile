# Start basic application example locally
basic-up:
	cd ./examples/basic && elm reactor

full-up:
	cd ./examples/full && npm run dev

# Generate documentation for preview
docs:
	elm make --docs=documentation.json

# Run unit tests locally
test-unit:
	npm test

test-unit-ci:
	npm install -g elm
	npm install -g elm-test
	elm-package install -y
	cd tests && elm-package install -y && cd ..
	elm-test

test-build-basic:
	cd examples/basic/
	elm make Main.elm

test-build-full:
	cd examples/full/
	elm make src/Main.elm

test-ci:
	make test-unit-ci
	make test-build-basic
	make test-build-full

.PHONY: docs test
