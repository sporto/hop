test-up:
	cd ./src/Test && elm reactor

basic-up:
	cd ./examples/basic && elm reactor

full-up:
	cd ./examples/full && elm reactor

flow:
	java -jar /usr/local/bin/plantuml.jar -ttxt assets/flow.pu

