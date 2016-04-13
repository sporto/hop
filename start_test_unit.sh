#!/bin/bash

cd test/unit
elm package install -y
npm test
