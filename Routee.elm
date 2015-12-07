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
  | GoToRoute String
  | GoToRouteResult (Result () ())
  | RouteChanged Erl.Url

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
    signal = hashChangeSignal,
    update = update config
  }

update config routerAction appModel =
  case routerAction of
    GoToRoute route ->
      (appModel, goToRouteFx route)
    GoToRouteResult result ->
      (appModel, Effects.none)
    RouteChanged url ->
      let
        (route, userAction) =
          routeDefintionForUrl config url
        params =
          paramsForRoute route url
        (updatedAppModel, fx) =
          config.update (userAction params) appModel
      in
        Debug.log "RouteChanged"
        (updatedAppModel, Effects.none)
    _ ->
      Debug.log "Router.NoOp"
      (appModel, Effects.none)

{- 
Each time the hash is changed get a signal
We need to pass this signal to the main application
-}
hashChangeSignal: Signal Action
hashChangeSignal =
  Signal.map  (\urlString -> RouteChanged (Erl.parse urlString)) History.hash

{-
Changes the hash
 -}
goToRouteFx: String -> (Effects Action)
goToRouteFx route =
  History.setPath route
    |> Task.toResult
    |> Task.map GoToRouteResult
    |> Effects.task

{-
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

{-
  Check if a route fragments matches 
  eg. (":id", "1") == True
-}
isRouteFragmentMatch: (String, String) -> Bool
isRouteFragmentMatch (actual, def) =
  if String.startsWith ":" def then
    Debug.log (actual ++ def)
    True
  else
    Debug.log (actual ++ def)
    (def == actual)

{-
  Given a config object and a current Url
  Return the params
-}
paramsForRoute: String -> Erl.Url -> Dict.Dict String String
paramsForRoute route url =
  Dict.empty
