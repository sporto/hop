module Hop (
  Payload,
  Params,
  Config,
  Router,
  RouteDefinition,
  Action,
  new,
  navigateTo,
  addQuery,
  setQuery,
  removeQuery,
  clearQuery
  ) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Types
@docs Config, Router, Payload, Params, RouteDefinition, Action

# Setup
@docs new

# Navigation
@docs navigateTo, addQuery, removeQuery, setQuery, clearQuery
-}

import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Dict

import Hop.Types as Types
import Hop.Url as Url
import Hop.Resolver as Resolver

-- TYPES

{-| Actions
-}
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
{-| Partial application action
-}
type alias UserPartialAction action = Types.UserPartialAction action

{-| Router record created by Hop.new
-}
type alias Router action = Types.Router action

{-| A route defintion
-}
type alias RouteDefinition action = Types.RouteDefinition action

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
    signal = locationChangeSignal config,
    payload = Types.newPayload,
    run = History.setPath ""
  }

{-
Each time the hash is changed get a signal
We need to pass this signal to the main application
-}
locationChangeSignal : Config (UserPartialAction action) -> Signal action
locationChangeSignal config =
  Signal.map (Resolver.userActionFromUrlString config) History.hash

{-| Changes the location (hash and query)

  NavigateTo will append "#/" if necessary

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (Hop.navigateTo path))
-}
navigateTo : String -> (Effects Action)
navigateTo route =
  route
    |> Url.urlFromUser
    |> navigateToUrl

{-
  Change the location
  using a Url record
-}
navigateToUrl : Types.Url -> (Effects Action)
navigateToUrl url =
  url
    |> Url.routeFromUrl
    |> History.setPath
    |> Task.toResult
    |> Task.map GoToRouteResult
    |> Effects.task

{-| Add query string values (patches any existing values)

    update action model =
      case action of
        ...
        AddQuery query ->
          (model, Effects.map HopAction (Hop.addQuery model.routerPayload.url query))

  To remove a value set the value to ""
-}
addQuery : Types.Url -> Types.Query -> (Effects Action)
addQuery currentUrl query =
  currentUrl
    |> Url.addQuery query
    |> navigateToUrl

{-| Set query string values (removes existing values)

    update action model =
      case action of
        ...
        SetQuery query ->
          (model, Effects.map HopAction (Hop.setQuery model.routerPayload.url query))
-}
setQuery : Types.Url -> Types.Query -> (Effects Action)
setQuery currentUrl query =
  currentUrl
    |> Url.setQuery query
    |> navigateToUrl

{-| Remove one query string value

    update action model =
      case action of
        ...
        RemoveQuery query ->
          (model, Effects.map HopAction (Hop.removeQuery model.routerPayload.url key))
-}
removeQuery : Types.Url -> String -> (Effects Action)
removeQuery currentUrl key =
  currentUrl
    |> Url.removeQuery key
    |> navigateToUrl

{-| Clear all query string values

    update action model =
      case action of
        ...
        ClearQuery ->
          (model, Effects.map HopAction (Hop.clearQuery model.routerPayload.url))
-}
clearQuery : Types.Url -> (Effects Action)
clearQuery currentUrl =
  currentUrl
    |> Url.clearQuery
    |> navigateToUrl
