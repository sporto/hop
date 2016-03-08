module Main (..) where

import String
import Graphics.Element exposing (Element)
import ElmTest exposing (..)
import Test.Tests as Tests


main : Element
main =
  elementRunner Tests.all
