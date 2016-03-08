module Test.Tests (..) where

import ElmTest exposing (..)


--import Hop.ResolverTest
--import Hop.UrlTest

import Hop.MatcherTest


all : Test
all =
  suite
    "Tests"
    [ Hop.MatcherTest.all
    ]
