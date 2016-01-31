module Hop.ResolverTest where

import Dict
import ElmTest exposing (..)
import Hop.Resolver as Resolver
import Hop.Url as Url

parseRouteFragment =
  let
    inputs =
      [
        ("/monkeys/:id", ["monkeys", ":id"])
      ]
    run (input, expected) =
      test "parseRouteFragment"
        (assertEqual expected (Resolver.parseRouteFragment input))
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
      Url.parse string
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
          Resolver.routeDefintionForUrl config url
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
        (
          "it adds the current id",
          "/monkeys/:id",
          Url.parse "#/monkeys/2",
          Dict.singleton "id" "2"
         ),
        (
          "it adds the current id",
          "/monkeys/:id",
          Url.parse "#/monkeys/2/edit",
          Dict.singleton "id" "2"
         ),
        (
          "it provides the query params",
          "/monkeys",
          Url.parse "#/monkeys?color=red",
          Dict.singleton "color" "red"
         ),
        (
          "it provides parent id and id",
          "/pirates/:pirateId/monkeys/:id",
          Url.parse "#/pirates/1/monkeys/2/edit",
          Dict.fromList [("pirateId", "1"), ("id","2")]
        )
      ]
    run (testCase, route, url, expected) =
      let
        actual =
          Resolver.paramsForRoute route url
        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite "paramsForRoute"
      (List.map run inputs)

all : Test
all =
  suite "ResolverTest"
    [
      parseRouteFragment,
      routeDefintionForUrl,
      paramsForRoute
    ]

