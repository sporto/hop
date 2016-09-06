module HopTest exposing (..)

import Dict
import ElmTest exposing (..)
import Hop exposing (..)
import Hop.Location as Location
import Hop.Types exposing (..)


config =
    { hash = True
    , basePath = ""
    }


configWithPath =
    { config | hash = False }


configWithBasePath =
    { configWithPath | basePath = "app" }


allTest : List Test
allTest =
    [ matchUrlTest, matcherToPathTest ]


all : Test
all =
    suite "MatcherTest" allTest
