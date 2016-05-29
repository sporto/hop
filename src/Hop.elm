module Hop exposing (matchUrl, matcherToPath, makeUrl, makeUrlFromLocation, addQuery, setQuery, removeQuery, clearQuery)

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Create URLs
@docs makeUrl, makeUrlFromLocation

# Change query string
@docs addQuery, setQuery, removeQuery, clearQuery

# Match current URL
@docs matchUrl

# Reverse Routing
@docs matcherToPath

-}

import String
import Dict
import Hop.Types exposing (..)
import Hop.Location
import Hop.Matching exposing (..)


---------------------------------------
-- MATCHING
---------------------------------------


{-|
matchUrl
-}
matchUrl : Config route -> String -> ( route, Hop.Types.Location )
matchUrl config url =
    let
        location =
            Hop.Location.fromUrl config url
    in
        ( matchLocation config location, location )


{-|
Generates a path from a matcher. Use this for reverse routing.

The last parameters is a list of strings. You need to pass one string for each dynamic parameter that this route takes.

    matcherToPath bookReviewMatcher ["1", "2"]

    ==

    "/books/1/reviews/2"
-}
matcherToPath : PathMatcher a -> List String -> String
matcherToPath matcher inputs =
    let
        inputs' =
            List.append inputs [ "" ]

        makeSegment segment input =
            segment ++ input

        path =
            List.map2 makeSegment matcher.segments inputs'
                |> String.join ""
    in
        path



---------------------------------------
-- CREATE URLs
---------------------------------------


{-| Create a url from ...

  navigateTo will append "#/" if necessary

    navigateTo config "/users"

  Example use in update:

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (navigateTo config path))
-}
makeUrl : Config route -> String -> String
makeUrl config route =
    route
        |> Hop.Location.locationFromUser
        |> makeUrlFromLocation config


{-|
Create an url from a location
-}
makeUrlFromLocation : Config route -> Location -> String
makeUrlFromLocation config location =
    let
        fullPath =
            Hop.Location.locationToFullPath config location

        path =
            if fullPath == "" then
                "/"
            else
                fullPath
    in
        path



-------------------------------------------------------------------------------
-- QUERY
-------------------------------------------------------------------------------


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



-------------------------------------------------------------------------------
-- QUERY MUTATION
-------------------------------------------------------------------------------


addQuery : Query -> Location -> Location
addQuery query location =
    let
        updatedQuery =
            Dict.union query location.query
    in
        { location | query = updatedQuery }


{-| Set query string values (removes existing values)

    setQuery config query location

Example use in update:

    update action model =
      case action of
        ...
        SetQuery query ->
          (model, Effects.map HopAction (setQuery config query model.location))
-}
setQuery : Query -> Location -> Location
setQuery query location =
    { location | query = query }


{-| Remove one query string value

    removeQuery config query location

Example use in update:

    update action model =
      case action of
        ...
        RemoveQuery query ->
          (model, Effects.map HopAction (removeQuery config key model.location))
-}
removeQuery : String -> Location -> Location
removeQuery key location =
    let
        updatedQuery =
            Dict.remove key location.query
    in
        { location | query = updatedQuery }


{-| Clear all query string values

    clearQuery config location

Example use in update:

    update action model =
      case action of
        ...
        ClearQuery ->
          (model, Effects.map HopAction (clearQuery config model.location))
-}
clearQuery : Location -> Location
clearQuery location =
    { location | query = Dict.empty }
