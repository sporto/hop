# Testing Hop

## Unit tests

```bash
cd ./test/unit
elm package install -y
npm i
npm test
```

## Unit test in Docker

For CI we use Docker (using docker compose) for testing, to try this locally:

```bash
make test-unit-docker
```

## Running integration test locally

You need Elixir installed and a webdriver e.g. phantomjs

Start application in localhost:

```bash
make test-up
```

And a webdriver (in a second terminal):

```
phantomjs --wd
```

Run tests in a third terminal:

```bash
cd test/integration/
APP_HOST=localhost APP_PORT=9000 ROUTER_HASH=0 WEBDRIVER_DRIVER=phantomjs mix test
```

## Integration test in Docker

To test CI Docker setup locally:

```bash
make test-int-docker
```
