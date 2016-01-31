module Tests where

import ElmTest exposing (..)
import Hop.ResolverTest
import Hop.UrlTest


-- normalizedUrl = 
--   let
--     inputs =
--       [
--         ("monkeys/1", "#/monkeys/1"),
--         ("/monkeys/1", "#/monkeys/1"),
--         ("#/monkeys/1", "#/monkeys/1"),
--         ("#monkeys/1", "#/monkeys/1"),
--         ("#/#monkeys/1", "#/monkeys/1"),
--         ("?a=1#monkeys/1", "?a=1#/monkeys/1"),
--         ("?a=1#/monkeys/1", "?a=1#/monkeys/1")
--       ]
--     run (input, expected) =
--       let
--         actual =
--           Utils.normalizedUrl input
--       in
--         test input
--           (assertEqual expected actual)
--   in
--     suite "normalizedUrl"
--       (List.map run inputs)

all: Test
all = 
  suite "Tests"
    [ 
      Hop.ResolverTest.all,
      Hop.UrlTest.all
    ]
