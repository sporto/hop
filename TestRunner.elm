module Main where

import String
import Graphics.Element exposing (Element)

import ElmTest exposing (..)
import Tests

main : Element
main = 
    elementRunner Tests.all
