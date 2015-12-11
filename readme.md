# A Router for Elm

## TODO:

- Call Router from sub view
	- Sub view should not call a parent action, only its own
	- Maybe the whole thing needs to be done using effects instead of actions?

- When hash changes, resolve the intended action and call it
- Make sure it works with nested components
- Show initial view upon load
- Pass current fragment params to the actions e.g. :userId = 1
- Pass query string to view
- Move the router signal to Routee

## Running tests

```
elm reactor
```

Open /localhost:8000/TestRunner.elm

## Running in Docker

docker-machine ip name-of-machine

docker-compose build
docker-compose up

Open in ip:8000
