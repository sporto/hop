module Hop (
  Payload,
  Params,
  Config,
  Router,
  RouteDefinition,
  new,
  navigateTo,
  setQuery,
  clearQuery
  ) where

{-| A router for single page applications

# Types
@docs Config, Router, Payload, Params, RouteDefinition

# Setup
@docs new

# Navigation
@docs navigateTo, setQuery, clearQuery
-}

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Dict
import Hop.Utils exposing (..)
import Hop.Types as Types

-- TYPES

type Action
  = NoOp
  | GoToRouteResult (Result () ()) -- We don't care about this one, remove

{-| Payload returned by the router when calling routing actions
-}
type alias Payload = Types.Payload

{-| A Dict that holds parameters for the current route
-}
type alias Params = Types.Params

{-| Configuration input for Hop.new
-}
type alias Config partialAction = Types.Config partialAction
type alias UserPartialAction action = Types.UserPartialAction action

{-| Router record created by Hop.new
-}
type alias Router action = Types.Router action

{-| A route defintion
-}
type alias RouteDefinition action = Types.RouteDefinition action

newPayload : Payload
newPayload = {
    params = Dict.empty,
    url = Erl.new
  }

{-| Create a Hop.Router

    router =
      Hop.new {
        routes = routes,
        notFoundAction = ShowNotFound
      }
-}
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

{-| Changes the location (hash and query)

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (Hop.navigateTo path))
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

{-| Set query string values

    update action model =
      case action of
        ...
        SetQuery query ->
          (model, Effects.map HopAction (Hop.setQuery model.routerPayload.url query))

  To remove a value set the value to ""
-}
setQuery : Erl.Url -> Params -> (Effects Action)
setQuery currentUrl query =
  let
    urlWithQuery =
      Dict.toList query
        |> List.foldl (\(key, val) -> Erl.setQuery key val ) currentUrl
  in
    navigateToUrl urlWithQuery

{-| Clear all query string values

    update action model =
      case action of
        ...
        ClearQuery ->
          (model, Effects.map HopAction (Hop.clearQuery model.routerPayload.url))
-}
clearQuery : Erl.Url -> (Effects Action)
clearQuery currentUrl =
  let
    urlWithoutQuery =
      Erl.clearQuery currentUrl
  in
    navigateToUrl urlWithoutQuery
