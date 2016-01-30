module Tests where

import String
import Dict
import Erl
import Hop
import Html
import Hop
import Hop.Utils as Utils

import ElmTest exposing (..)

parseRouteFragment =
  let
    inputs =
      [
        ("/monkeys/:id", ["monkeys", ":id"])
      ]
    run (input, expected) =
      test "parseRouteFragment"
        (assertEqual expected (Utils.parseRouteFragment input))
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

normalizedUrl = 
  let
    inputs =
      [
        ("monkeys/1", "#/monkeys/1"),
        ("/monkeys/1", "#/monkeys/1"),
        ("#/monkeys/1", "#/monkeys/1"),
        ("#monkeys/1", "#/monkeys/1"),
        ("#/#monkeys/1", "#/monkeys/1"),
        ("?a=1#monkeys/1", "?a=1#/monkeys/1"),
        ("?a=1#/monkeys/1", "?a=1#/monkeys/1")
      ]
    run (input, expected) =
      let
        actual =
          Utils.normalizedUrl input
      in
        test input
          (assertEqual expected actual)
  in
    suite "normalizedUrl"
      (List.map run inputs)

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
          Utils.routeDefintionForUrl config url
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
          Utils.paramsForRoute route url
      in
        test "paramsForRoute"
          (assertEqual expectedParams actualParams)
  in
    suite "paramsForRoute"
      (List.map run inputs)

routeFromUrl =
  let
    empty =
      Erl.new
    inputs =
      [
        (empty, ""),
        ({empty | hash = ["a"] }, "#a"),
        ({empty | query = Dict.singleton "k" "1" }, "?k=1"),
        ({empty | query = Dict.singleton "k" "1", hash = ["a"]  }, "?k=1#a")
      ]
    run (url, expected) =
      let
        actual =
          Utils.routeFromUrl url
      in
        test "routeFromUrl"
          (assertEqual expected actual)
  in
    suite "routeFromUrl"
      (List.map run inputs)

all: Test
all = 
  suite "Tests"
    [ 
      normalizedUrl,
      paramsForRoute,
      parseRouteFragment,
      routeDefintionForUrl,
      routeFromUrl
    ]

