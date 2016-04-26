module Hop.Navigate (navigateTo, addQuery, setQuery, removeQuery, clearQuery) where

{-| Functions for changing the browser location

@docs navigateTo, addQuery, removeQuery, setQuery, clearQuery
-}

import Effects exposing (Effects)
import History
import Hop.Location as Location
import Hop.Types exposing (..)


{-| Changes the location (hash and query)

  navigateTo will append "#/" if necessary

    navigateTo config "/users"

  Example use in update:

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (navigateTo config path))
-}
navigateTo : Config route -> String -> Effects ()
navigateTo config route =
  route
    |> Location.locationFromUser
    |> navigateToLocation config


{-| @private
Change the location using a Location record
-}
navigateToLocation : Config route -> Location -> Effects ()
navigateToLocation config location =
  let
    fullPath =
      Location.locationToFullPath config location

    path =
      if fullPath == "" then
        "/"
      else
        fullPath
  in
    History.setPath path |> Effects.task



-------------------------------------------------------------------------------
-- QUERY


{-| Add query string values (patches any existing values)

    addQuery config query location

- config is the router Config record
- query is a dictionary with keys to add
- location is a record representing the current location

Example use in update:

    update action model =
      case action of
        ...
        AddQuery query ->
          (model, Effects.map HopAction (addQuery config query model.location))

To remove a value set the value to ""
-}
addQuery : Config route -> Query -> Location -> Effects ()
addQuery config query currentLocation =
  currentLocation
    |> Location.addQuery query
    |> navigateToLocation config


{-| Set query string values (removes existing values)

    setQuery config query location

Example use in update:

    update action model =
      case action of
        ...
        SetQuery query ->
          (model, Effects.map HopAction (setQuery config query model.location))
-}
setQuery : Config route -> Query -> Location -> Effects ()
setQuery config query currentLocation =
  currentLocation
    |> Location.setQuery query
    |> navigateToLocation config


{-| Remove one query string value

    removeQuery config query location

Example use in update:

    update action model =
      case action of
        ...
        RemoveQuery query ->
          (model, Effects.map HopAction (removeQuery config key model.location))
-}
removeQuery : Config route -> String -> Location -> Effects ()
removeQuery config key currentLocation =
  currentLocation
    |> Location.removeQuery key
    |> navigateToLocation config


{-| Clear all query string values

    clearQuery config location

Example use in update:

    update action model =
      case action of
        ...
        ClearQuery ->
          (model, Effects.map HopAction (clearQuery config model.location))
-}
clearQuery : Config route -> Location -> Effects ()
clearQuery config currentLocation =
  currentLocation
    |> Location.clearQuery
    |> navigateToLocation config
