module Tests where

import ElmTest exposing (..)
import Hop.ResolverTest
import Hop.UrlTest

all: Test
all = 
  suite "Tests"
    [ 
      Hop.ResolverTest.all,
      Hop.UrlTest.all
    ]
