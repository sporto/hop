module Tests where

import String
import Dict
import Erl
import Routee

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

parseRouteFragmentTest =
  let
    inputs =
      [
        ("/users/:id", ["users", "id"])
      ]
    run (input, expected) =
      test "parseRouteFragment"
        (assertEqual expected (Routee.parseRouteFragment input))
  in
    suite "parseRouteFragment"
      (List.map run inputs)

-- suite : String -> List Test -> Test
all: Test
all = 
  suite "Tests"
    [ 
      parseRouteFragmentTest
    ]
