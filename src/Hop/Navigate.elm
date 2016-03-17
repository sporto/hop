module Hop.Navigate (navigateTo, addQuery, setQuery, removeQuery, clearQuery) where

{-| Functions for changing the browser location

@docs navigateTo, addQuery, removeQuery, setQuery, clearQuery
-}

import Effects exposing (Effects, Never)
import History
import Hop.Location as Location
import Hop.Types exposing (..)


{-| Changes the location (hash and query)

  navigateTo will append "#/" if necessary

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (navigateTo path))
-}
navigateTo : String -> Effects ()
navigateTo route =
  route
    |> Location.locationFromUser
    |> navigateToLocation



{-
@private
navigateToLocation
Change the location using a Location record
-}


navigateToLocation : Location -> Effects ()
navigateToLocation location =
  location
    |> Location.locationToFullPath
    |> History.setPath
    |> Effects.task



-------------------------------------------------------------------------------
-- QUERY


{-| Add query string values (patches any existing values)

    update action model =
      case action of
        ...
        AddQuery query ->
          (model, Effects.map HopAction (Hop.addQuery query model.location))

  To remove a value set the value to ""
-}
addQuery : Query -> Location -> Effects ()
addQuery query currentLocation =
  currentLocation
    |> Location.addQuery query
    |> navigateToLocation


{-| Set query string values (removes existing values)

    update action model =
      case action of
        ...
        SetQuery query ->
          (model, Effects.map HopAction (Hop.setQuery query model.location))
-}
setQuery : Query -> Location -> Effects ()
setQuery query currentLocation =
  currentLocation
    |> Location.setQuery query
    |> navigateToLocation


{-| Remove one query string value

    update action model =
      case action of
        ...
        RemoveQuery query ->
          (model, Effects.map HopAction (Hop.removeQuery key model.location))
-}
removeQuery : String -> Location -> Effects ()
removeQuery key currentLocation =
  currentLocation
    |> Location.removeQuery key
    |> navigateToLocation


{-| Clear all query string values

    update action model =
      case action of
        ...
        ClearQuery ->
          (model, Effects.map HopAction (Hop.clearQuery model.location))
-}
clearQuery : Location -> Effects ()
clearQuery currentLocation =
  currentLocation
    |> Location.clearQuery
    |> navigateToLocation
