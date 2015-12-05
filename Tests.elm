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

parseRouteFragment =
  let
    inputs =
      [
        ("/monkeys/:id", ["monkeys", ":id"])
      ]
    run (input, expected) =
      test "parseRouteFragment"
        (assertEqual expected (Routee.parseRouteFragment input))
  in
    suite "parseRouteFragment"
      (List.map run inputs)

type Action
  = NotFound
  | Monkeys
  | Monkey
  | MonkeyEdit
  | MonkeyPunch
  | Tigers
  | Tiger

routes = 
  [
    ("/monkeys", Monkeys),
    ("/monkeys/:id", Monkey),
    ("/monkeys/:id/edit", MonkeyEdit),
    ("/monkeys/:id/punch", MonkeyPunch),
    ("/tigers", Tigers),
    ("/tigers/:id", Tiger)
  ]

actionForUrl =
  let
    inputs =
      [
        ("#/monkeys", Monkeys),
        ("#/monkeys/2", Monkey),
        ("#/monkeys/2/edit", MonkeyEdit),
        ("#/monkeys/2/punch", MonkeyPunch),
        ("#/tigers", Tigers),
        ("#/tigers/1", Tiger)
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

all: Test
all = 
  suite "Tests"
    [ 
      actionForUrl,
      parseRouteFragment
    ]

