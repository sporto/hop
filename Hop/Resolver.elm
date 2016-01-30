module Hop.Resolver where

import String
import Dict
import Hop.Types as Types
import Hop.Url as Url

{-
  Resolver
  Takes current route + route definitons and returns parameters for views
-}

userActionFromUrlString : Types.Config (Types.UserPartialAction action) -> String -> action
userActionFromUrlString config urlString =
  let
    url
      = Url.parse urlString
    (route, userAction) =
      routeDefintionForUrl config url
    params =
      paramsForRoute route url
    payload = {
        params = params,
        url = url
      } 
  in
    userAction payload

{-
  Given a route and a current Url
  Return the params
  Includes the query string
  e.g. "/users/:id" -> url -> dict
-}
paramsForRoute : String -> Types.Url -> Types.Params
paramsForRoute routeDefinition url =
  let
    routeFragments =
      parseRouteFragment routeDefinition
    maybeParam routeFragment urlFragment =
      if isRouteHashPlaceholder routeFragment then
        (String.dropLeft 1 routeFragment, urlFragment)
      else
        ("", "")
    params =
      List.map2 maybeParam routeFragments url.path
    relevantParams =
      List.filter (\(x, _) -> not (String.isEmpty x)) params
  in
    Dict.fromList relevantParams
      |> Dict.union url.query

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

routeDefintionForUrl : Types.Config partialAction -> Types.Url -> Types.RouteDefinition partialAction
routeDefintionForUrl config url =
  matchedRoute config.routes url
    |> Maybe.withDefault ("", config.notFoundAction)

{-
  Given the routes and the current url
  Return the route tuple that matches
-}
matchedRoute : List (Types.RouteDefinition action) -> Types.Url -> Maybe (Types.RouteDefinition action)
matchedRoute routes url =
  routes
    |> List.filter (isRouteMatch url)
    |> List.head

{-
  Given an url and a route definition
  Return Bool if it matches
-}
isRouteMatch : Types.Url -> (Types.RouteDefinition action) -> Bool
isRouteMatch url routeDef =
  let
    currentFragmentList =
      url.path
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

