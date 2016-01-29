module Hop.Utils where

import Erl
import String
import Dict
import Debug
import Hop.Types as Types

routeFromUrl : Erl.Url -> String
routeFromUrl url =
  let
    path =
      Erl.toString url
  in
    if String.contains "?" path then
      path
        |> String.split "?"
        |> List.drop 1
        |> List.head
        |> Maybe.withDefault ""
        |> String.append "?"
    else 
      if String.contains "#" path then
        path
          |> String.split "#"
          |> List.drop 1
          |> List.head
          |> Maybe.withDefault ""
          |> String.append "#"
        else
          ""

{-
Take the route defintion and return a List
"/users/:id" --> ["users", ":id"]
-}
parseRouteFragment : String -> List String
parseRouteFragment route =
  let
    notEmpty x=
      not (String.isEmpty x)
  in
    route
      |> String.split "/"
      |> List.filter notEmpty

routeDefintionForUrl : Types.Config partialAction -> Erl.Url -> Types.RouteDefinition partialAction
routeDefintionForUrl config url =
  matchedRoute config.routes url
    |> Maybe.withDefault ("", config.notFoundAction)

{-
  Given the routes and the current url
  Return the route tuple that matches
-}
matchedRoute : List (Types.RouteDefinition action) -> Erl.Url -> Maybe (Types.RouteDefinition action)
matchedRoute routes url =
  routes
    |> List.filter (isRouteMatch url)
    |> List.head

{-
  Given an url and a route definition
  Return Bool if it matches
-}
isRouteMatch : Erl.Url -> (Types.RouteDefinition action) -> Bool
isRouteMatch url routeDef =
  let
    currentFragmentList =
      url.hash
    currentLen =
      List.length currentFragmentList
    definitionFragmentList =
      parseRouteFragment (fst routeDef)
    definitionFragmentLen =
      List.length definitionFragmentList
    combinedCurrentAndDefinition =
      List.map2 (,) currentFragmentList definitionFragmentList
  in
    if currentLen == definitionFragmentLen then
      List.all isRouteFragmentMatch combinedCurrentAndDefinition
    else
      False

{-
  Check if a route hash matches 
  eg. (":id", "1") == True
-}
isRouteFragmentMatch : (String, String) -> Bool
isRouteFragmentMatch (actual, def) =
  if isRouteHashPlaceholder def then
    True
  else
    (def == actual)

isRouteHashPlaceholder : String -> Bool
isRouteHashPlaceholder hash =
  String.startsWith ":" hash

{-
  Given a route and a current Url
  Return the params
  Includes the query string
  e.g. "/users/:id" -> url -> dict
-}
paramsForRoute : String -> Erl.Url -> Dict.Dict String String
paramsForRoute route url =
  let
    routeFragments =
      parseRouteFragment route
    maybeParam routeFragment urlFragment =
      if isRouteHashPlaceholder routeFragment then
        (String.dropLeft 1 routeFragment, urlFragment)
      else
        ("", "")
    params =
      List.map2 maybeParam routeFragments url.hash
    relevantParams =
      List.filter (\(x, _) -> not (String.isEmpty x)) params
  in
    Dict.fromList relevantParams
      |> Dict.union url.query

{-
  Cleans up url
-}
normalizedUrl : String -> String
normalizedUrl route =
  let
    afterHash =
      if String.contains "#" route then
        route
          |> String.split "#"
          |> List.reverse
          |> List.head
          |> Maybe.withDefault ""
      else
        route
  in
    if String.startsWith "/" afterHash then
      "#" ++ afterHash
    else
      "#/" ++ afterHash
