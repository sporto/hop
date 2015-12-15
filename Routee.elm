module Routee where

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Dict

type Action
  = NoOp
  | GoToRouteResult (Result () ()) -- We don't care about this one, remove

type alias Params = Dict.Dict String String

type alias Payload = {
    params: Params,
    url: Erl.Url
  }

type alias UserPartialAction action = Payload -> action

type alias Config partialAction = {
    notFoundAction: partialAction,
    routes: List (RouteDefinition partialAction)
  }

type alias Router action = {
    signal: Signal action,
    payload: Payload,
    run: Task () ()
  }

type alias RouteDefinition action = (String, action)

newPayload : Payload
newPayload = {
    params = Dict.empty,
    url = Erl.new
  }

new: Config (UserPartialAction action) -> Router action
new config =
  {
    signal = hashChangeSignal config,
    payload = newPayload,
    run = History.setPath ""
  }

{-
Each time the hash is changed get a signal
We need to pass this signal to the main application
-- ! And here as well, map to the correct user'action
-}
hashChangeSignal : Config (UserPartialAction action) -> Signal action
hashChangeSignal config =
    Signal.map (userActionFromUrlString config) History.hash

userActionFromUrlString : Config (UserPartialAction action) -> String -> action
userActionFromUrlString config urlString =
  let
    url
      = Erl.parse urlString
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
  Changes the location (hash and query)
  using a string
 -}
navigateTo : String -> (Effects Action)
navigateTo route =
  let
    withSlash =
      if String.startsWith "/" route then
        route
      else
        "/" ++ route
    withHash =
      "#" ++ withSlash
  in
    History.setPath withHash
      |> Task.toResult
      |> Task.map GoToRouteResult
      |> Effects.task

{-
  Change the location
  using a Erl.Url record
-}
navigateToUrl : Erl.Url -> (Effects Action)
navigateToUrl url =
  let
    path =
      Erl.toString url
    route =
      String.split "#" path
        |> List.drop 1
        |> List.head
        |> Maybe.withDefault ""
  in
    navigateTo route

setQuery : Erl.Url -> Params -> (Effects Action)
setQuery currentUrl query =
  let
    urlWithQuery =
      Dict.toList query
        |> List.foldl (\(key, val) -> Erl.setQuery key val ) currentUrl
  in
    navigateToUrl urlWithQuery

clearQuery : Erl.Url -> (Effects Action)
clearQuery currentUrl =
  let
    urlWithoutQuery =
      Erl.clearQuery currentUrl
  in
    navigateToUrl urlWithoutQuery

{-
Take the route defintion and return a List
"/users/:id" --> ["users", ":id"]
-}
parseRouteFragment: String -> List String
parseRouteFragment route =
  let
    notEmpty x=
      not (String.isEmpty x)
  in
    route
      |> String.split "/"
      |> List.filter notEmpty

routeDefintionForUrl : Config partialAction -> Erl.Url -> RouteDefinition partialAction
routeDefintionForUrl config url =
  matchedRoute config.routes url
    |> Maybe.withDefault ("", config.notFoundAction)

{-
  Given the routes and the current url
  Return the route tuple that matches
-}
matchedRoute: List (RouteDefinition action) -> Erl.Url -> Maybe (RouteDefinition action)
matchedRoute routes url =
  routes
    |> List.filter (isRouteMatch url)
    |> List.head

{-
  Given an url and a route definition
  Return Bool if it matches
-}
isRouteMatch: Erl.Url -> (RouteDefinition action) -> Bool
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

isRouteHashPlaceholder: String -> Bool
isRouteHashPlaceholder hash =
  String.startsWith ":" hash

{-
  Check if a route hash matches 
  eg. (":id", "1") == True
-}
isRouteFragmentMatch: (String, String) -> Bool
isRouteFragmentMatch (actual, def) =
  if isRouteHashPlaceholder def then
    True
  else
    (def == actual)

{-
  Given a route and a current Url
  Return the params
  Includes the query string
  e.g. "/users/:id" -> url -> dict
-}
paramsForRoute: String -> Erl.Url -> Dict.Dict String String
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
