module Main where

import String
import Graphics.Element exposing (Element)

import ElmTest.Test exposing (..)
import ElmTest.Runner.Element exposing (runDisplay)
import Tests

main : Element
main = 
    runDisplay Tests.all
