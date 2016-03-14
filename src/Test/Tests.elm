module Test.Tests (..) where

import ElmTest exposing (..)


--import Hop.ResolverTest
--import Hop.UrlTest
--import Hop.MatcherTest

import Hop.UrlTest
import Hop.MatcherTest


all : Test
all =
  suite
    "Tests"
    [ Hop.UrlTest.all
    , Hop.MatcherTest.all
    ]
