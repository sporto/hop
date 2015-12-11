module Routee where

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Debug
import Html
import Dict

type Action
  = NoOp
  | GoToRouteResult (Result () ()) -- We don't care about this one, remove

type alias Params = Dict.Dict String String

--type alias Config action model = {
--    notFoundAction: action,
--    routes: List (String, action),
--    update: (action -> model -> (model, Effects action))
--  }

--type alias Library model = {
--    signal: Signal Action,
--    update: Action -> model -> (model, Effects Action)
--  }

type alias RouteDefinition action = (String, action)

--new: Config action model -> Library model
new config =
  {
    signal = hashChangeSignal config
  }

{- 
Each time the hash is changed get a signal
We need to pass this signal to the main application
-- ! And here as well, map to the correct user'action
-}
--hashChangeSignal: Signal Action
hashChangeSignal config =
    Signal.map (userActionFromUrlString config) History.hash

userActionFromUrlString config urlString =
  let
    url
      = Erl.parse urlString
    (route, userAction) =
      routeDefintionForUrl config url
    params =
      paramsForRoute route url
  in
    userAction params

{-
Changes the hash
 -}
--navigateTo: String -> (Effects Action)
-- Assume route doesnt have a hash
navigateTo route =
  let
    route' =
      "#" ++ route
  in
    History.setPath route'
      |> Task.toResult
      |> Task.map GoToRouteResult
      |> Effects.task

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

--actionForUrl: List (RouteDefinition action) -> action -> Erl.Url -> action
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
      url.fragment
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

isRouteFragmentPlaceholder: String -> Bool
isRouteFragmentPlaceholder fragment =
  String.startsWith ":" fragment

{-
  Check if a route fragments matches 
  eg. (":id", "1") == True
-}
isRouteFragmentMatch: (String, String) -> Bool
isRouteFragmentMatch (actual, def) =
  if isRouteFragmentPlaceholder def then
    True
  else
    (def == actual)

{-
  Given a config object and a current Url
  Return the params
-}
paramsForRoute: String -> Erl.Url -> Dict.Dict String String
paramsForRoute route url =
  let
    routeFragments =
      parseRouteFragment route
    maybeParam routeFragment urlFragment =
      if isRouteFragmentPlaceholder routeFragment then
        (String.dropLeft 1 routeFragment, urlFragment)
      else
        ("", "")
    params =
      List.map2 maybeParam routeFragments url.fragment
    relevantParams =
      List.filter (\(x, _) -> not (String.isEmpty x)) params
  in
    Dict.fromList relevantParams
