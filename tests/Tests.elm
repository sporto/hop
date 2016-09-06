module Tests exposing (..)

import Hop.AddressTest
import Hop.InTest
import Hop.OutTest
import Test exposing (..)


all : Test
all =
  describe "Hop"
    [ Hop.AddressTest.all
    , Hop.InTest.all
    , Hop.OutTest.all
    ]
