module Test.Tests (..) where

import ElmTest exposing (..)
import Hop.UrlTest
import Hop.MatchersTest


all : Test
all =
  suite
    "Tests"
    [ Hop.UrlTest.all
    , Hop.MatchersTest.all
    ]
