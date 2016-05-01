#!/bin/bash

mix deps.get

# Wait for test_app_hash
echo "Looking for test_app_hash"
until nc -z test_app_hash 9001; do
  echo "Waiting for test_app_hash:9001"
  sleep 1
done
echo "Found test_app_hash"

# Wait for test_app_path
echo "Looking for test_app_path"
until nc -z test_app_path 9002; do
  echo "Waiting for test_app_path:9002"
  sleep 1
done
echo "Found test_app_path"

# Wait for test_app_basepath
echo "Looking for test_app_basepath"
until nc -z test_app_basepath 9003; do
  echo "Waiting for test_app_basepath:9003"
  sleep 1
done
echo "Found test_app_basepath"

# Wait for Webdriver
echo "Looking for $WEBDRIVER_HOST"
until nc -z $WEBDRIVER_HOST $WEBDRIVER_PORT; do
  echo "Waiting for $WEBDRIVER_HOST ..."
  sleep 1
done
echo "Found $WEBDRIVER_HOST"

echo "=== Testing hash routing ==="
APP_HOST=test_app_hash APP_PORT=9001 ROUTER_HASH=1 mix test

echo "=== Testing path routing ==="
APP_HOST=test_app_path APP_PORT=9002 ROUTER_HASH=0 mix test

echo "=== Testing path and basepath routing ==="
APP_HOST=test_app_basepath APP_PORT=9003 ROUTER_HASH=0 ROUTER_BASEPATH=/app mix test
