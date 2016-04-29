#!/bin/bash

mix deps.get

# Wait for test_app_hash
echo "Looking for test_app_hash"
until nc -z test_app_hash 9000; do
  echo "Waiting for test_app_hash:9000"
  sleep 1
done
echo "Found test_app_hash"

# Wait for test_app_path
echo "Looking for test_app_path"
until nc -z test_app_path 9001; do
  echo "Waiting for test_app_path:9001"
  sleep 1
done
echo "Found test_app_path"

# Wait for test_app_basepath
echo "Looking for test_app_basepath"
until nc -z test_app_basepath 9002; do
  echo "Waiting for test_app_basepath:9002"
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

mix test test/$TEST_DIR
