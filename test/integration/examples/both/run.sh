#!/bin/bash

mix deps.get

# Wait for Elm
echo "Looking for $APP_HOST"
until nc -z $APP_HOST $APP_PORT; do
  echo "Waiting for $APP_HOST ..."
  sleep 1
done
echo "Found $APP_HOST"

# Wait for Webdriver
echo "Looking for $WEBDRIVER_HOST"
until nc -z $WEBDRIVER_HOST $WEBDRIVER_PORT; do
  echo "Waiting for $WEBDRIVER_HOST ..."
  sleep 1
done
echo "Found $WEBDRIVER_HOST"

mix test test/$TEST_DIR
