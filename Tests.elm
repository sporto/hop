module Tests where

import String
import Dict
import Erl
import Routee
import Html
import Routee

import ElmTest exposing (..)

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

update = 
  1

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
    config =
      {
        notFoundAction = NotFound,
        routes = routes,
        update = update
      }
    run (input, expected) =
      let
        url =
          toUrl input
        actual =
          Routee.actionForUrl config url
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

