# Start basic application example locally
basic-up:
	cd ./examples/basic && elm reactor

full-up:
	cd ./examples/full && npm run dev

# Generate documentation for preview
docs:
	elm make --docs=documentation.json

### TEST LOCALLY

# Run unit tests locally
test-unit:
	npm test

.PHONY: docs test
