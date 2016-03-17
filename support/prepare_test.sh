#!/bin/bash

# nvm use 4.0 # already done in CI
node --version
npm --version
npm install -g elm

echo "============================"
echo "Installing deps for test"
cd ./test && npm install
cd ./test && elm package install -y

echo "============================"
echo "Installing deps for basic app"
cd ./examples/basic && elm package install -y

echo "============================"
echo "Installing deps for full app"
cd ./examples/full && elm package install -y
