module Hop exposing (matchUrl, matcherToPath, makeUrl, makeUrlFromLocation, addQuery, setQuery, removeQuery, clearQuery)

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Create URLs
@docs makeUrl, makeUrlFromLocation

# Match current URL
@docs matchUrl

# Reverse Routing
@docs matcherToPath

# Change query string
@docs addQuery, setQuery, removeQuery, clearQuery

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
Match a URL.
This function returns a tuple with the first element being the matched route and the second a location record.
Config is the router Config record.

    matchUrl config "/users/1"

    ==

    (User 1, { path = ["users", "1"], query = Dict.fromList [] })

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


{-|
Make a URL from a string, this will add # or the base path as necessary.

    makeUrl config "/users"

    ==

    "#/users"
-}
makeUrl : Config route -> String -> String
makeUrl config route =
    route
        |> Hop.Location.locationFromUser
        |> makeUrlFromLocation config


{-|
Make a URL from a location record.

    makeUrlFromLocation config { path = ["users", "1"], query = Dict.empty }

    ==

    "#/users/1"

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
-- QUERY MUTATION
-------------------------------------------------------------------------------


{-|
Add query string values (patches any existing values) to a location record.

    addQuery query location

    addQuery (Dict.Singleton "b" "2") { path = [], query = Dict.fromList [("a", "1")] }

    ==

    { path = [], query = Dict.fromList [("a", "1"), ("b", "2")] }

- query is a dictionary with keys to add
- location is a record representing the current location

To remove a value set the value to ""
-}
addQuery : Query -> Location -> Location
addQuery query location =
    let
        updatedQuery =
            Dict.union query location.query
    in
        { location | query = updatedQuery }


{-|
Set query string values (removes existing values).

    setQuery query location
-}
setQuery : Query -> Location -> Location
setQuery query location =
    { location | query = query }


{-|
Remove one key from the query string

    removeQuery key location
-}
removeQuery : String -> Location -> Location
removeQuery key location =
    let
        updatedQuery =
            Dict.remove key location.query
    in
        { location | query = updatedQuery }


{-| Clear all query string values

    clearQuery location
-}
clearQuery : Location -> Location
clearQuery location =
    { location | query = Dict.empty }
