module Hop.Navigate (navigateTo, addQuery, setQuery, removeQuery, clearQuery) where

{-| Functions for changing the browser location

@docs navigateTo, addQuery, removeQuery, setQuery, clearQuery
-}

import Effects exposing (Effects, Never)
import History
import Hop.Url as Url
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
    |> Url.urlFromUser
    |> navigateToUrl



{-
@private
navigateToUrl
Change the location using a Url record
-}


navigateToUrl : Url -> Effects ()
navigateToUrl url =
  url
    |> Url.urlToLocation
    |> History.setPath
    |> Effects.task



-------------------------------------------------------------------------------
-- QUERY


{-| Add query string values (patches any existing values)

    update action model =
      case action of
        ...
        AddQuery query ->
          (model, Effects.map HopAction (Hop.addQuery query model.routerPayload.url))

  To remove a value set the value to ""
-}
addQuery : Query -> Url -> Effects ()
addQuery query currentUrl =
  currentUrl
    |> Url.addQuery query
    |> navigateToUrl


{-| Set query string values (removes existing values)

    update action model =
      case action of
        ...
        SetQuery query ->
          (model, Effects.map HopAction (Hop.setQuery query model.routerPayload.url))
-}
setQuery : Query -> Url -> Effects ()
setQuery query currentUrl =
  currentUrl
    |> Url.setQuery query
    |> navigateToUrl


{-| Remove one query string value

    update action model =
      case action of
        ...
        RemoveQuery query ->
          (model, Effects.map HopAction (Hop.removeQuery key model.routerPayload.url))
-}
removeQuery : String -> Url -> Effects ()
removeQuery key currentUrl =
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
clearQuery : Url -> Effects ()
clearQuery currentUrl =
  currentUrl
    |> Url.clearQuery
    |> navigateToUrl
