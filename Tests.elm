module Tests where

import String
import Dict
import Erl
import Routee
import Html
import Routee

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

-- Dummies
--viewUsers address model = 
--  Html.div [] []

--parseRouteFragmentTest =
--  let
--    inputs =
--      [
--        ("/users/:id", ["users", ":id"])
--      ]
--    run (input, expected) =
--      test "parseRouteFragment"
--        (assertEqual expected (Lib.Matcher.parseRouteFragment input))
--  in
--    suite "parseRouteFragment"
--      (List.map run inputs)

-- matchedView

type Action
  = NotFound
  | Hello

routes = 
  [
    ("/hello", Hello)
  ]

actionForUrl =
  let
    inputs =
      [
        ("#/hello/2", Hello)
      ]
    toUrl string =
      Erl.parse string
    run (input, expected) =
      let
        url =
          toUrl input
        actual =
          Routee.actionForUrl routes NotFound url
      in
        test "actionForUrl"
          (assertEqual expected actual)
  in
    suite "matchedRoute"
      (List.map run inputs)

-- suite : String -> List Test -> Test
all: Test
all = 
  suite "Tests"
    [ 
      actionForUrl
    ]

