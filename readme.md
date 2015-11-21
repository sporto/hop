# A Router for Elm

## TODO:

- Application needs to provide an outlet to render current view
- When hash changes, resolve the intended view and show that
- Show initial view upon load
- Pass current fragment params to view e.g. :userId = 1
- Pass query string to view

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
