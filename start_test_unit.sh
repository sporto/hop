#!/bin/bash

cd test/unit
elm package install -y
elm-test TestRunner.elm
