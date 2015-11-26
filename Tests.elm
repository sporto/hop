module Tests where

import String
import Dict
import Erl
import Routee
import Html
import Lib.Matcher

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

-- Dummies
--viewUsers address model = 
--  Html.div [] []

parseRouteFragmentTest =
  let
    inputs =
      [
        ("/users/:id", ["users", ":id"])
      ]
    run (input, expected) =
      test "parseRouteFragment"
        (assertEqual expected (Lib.Matcher.parseRouteFragment input))
  in
    suite "parseRouteFragment"
      (List.map run inputs)

-- matchedView

routes = 
  [
    ("/hello", 1)
  ]

matchedRouteTest =
  let
    inputs =
      [
        ("#/hello/2", 1)
      ]
    toUrl string =
      Erl.parse string
    run (input, expected) =
      let
        actual =
          Lib.Matcher.matchedView routes (toUrl input)
      in
        test "matchedRoute"
          (assertEqual expected actual)
  in
    suite "matchedRoute"
      (List.map run inputs)

-- suite : String -> List Test -> Test
all: Test
all = 
  suite "Tests"
    [ 
      matchedRouteTest,
      parseRouteFragmentTest
    ]

