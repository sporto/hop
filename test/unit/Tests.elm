module Tests (..) where

import ElmTest exposing (..)
import Hop.LocationTest
import Hop.MatchersTest


all : Test
all =
  suite
    "Tests"
    [ Hop.LocationTest.all
    , Hop.MatchersTest.all
    ]
