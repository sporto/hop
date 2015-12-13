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

routeDefintionForUrl =
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
        routes = routes
      }
    run (input, expectedAction) =
      let
        url =
          toUrl input
        (_, actualAction) =
          Routee.routeDefintionForUrl config url
      in
        test "routeDefintionForUrl"
          (assertEqual expectedAction actualAction)
  in
    suite "matchedRoute"
      (List.map run inputs)

paramsForRoute = 
  let
    inputs =
      [
        ("/monkeys/:id", Erl.parse "#/monkeys/2", Dict.singleton "id" "2"),
        ("/monkeys/:id", Erl.parse "#/monkeys/2/edit", Dict.singleton "id" "2"),
        ("/monkeys", Erl.parse "#/monkeys?color=red", Dict.singleton "color" "red"),
        (
          "/pirates/:pirateId/monkeys/:id",
          Erl.parse "#/pirates/1/monkeys/2/edit",
          Dict.fromList [("pirateId", "1"), ("id","2")]
        )
      ]
    run (route, url, expectedParams) =
      let
        actualParams =
          Routee.paramsForRoute route url
      in
        test "paramsForRoute"
          (assertEqual expectedParams actualParams)
  in
    suite "paramsForRoute"
      (List.map run inputs)

all: Test
all = 
  suite "Tests"
    [ 
      routeDefintionForUrl,
      parseRouteFragment,
      paramsForRoute
    ]

