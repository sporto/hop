#!/bin/bash

mix local.hex --force
mix deps.get


# Wait for Elm
until nc -z app 8000; do
  echo "Waiting for app ..."
  sleep 1
done

# Wait for Chrome
until nc -z webdriver 4444; do
  echo "Waiting for webdriver ..."
  sleep 1
done


mix test
