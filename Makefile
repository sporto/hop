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

test:
	make test-hop
	make test-basic
	make test-full

.PHONY: docs
