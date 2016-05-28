module Tests exposing (..)

import ElmTest exposing (..)
import Hop.LocationTest
import HopTest

all : Test
all =
  suite
    "Tests"
    [ Hop.LocationTest.all
    , HopTest.all
    ]
