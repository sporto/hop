#!/bin/bash

cd examples/full
elm package install -y
npm i
npm run dev
