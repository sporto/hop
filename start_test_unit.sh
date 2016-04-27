#!/bin/bash

cd test/unit
./install-packages.sh
elm-test TestRunner.elm
