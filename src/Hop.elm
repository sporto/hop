module Hop exposing (Config, Location, Query, toNormLocation, toNormPath, toLocationRecord, locationToRealPath, toRealPath, addQuery, setQuery, removeQuery, clearQuery)

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Types
@docs Config, Location, Query

# Normalise URLs
@docs toNormLocation, toLocationRecord, toNormPath

# Create URLs
@docs toRealPath, locationToRealPath

# Change query string
@docs addQuery, setQuery, removeQuery, clearQuery

-}

import String
import Dict
import Hop.Types
import Hop.Location
import Regex

{-| A Dict that holds query parameters

    Dict.Dict String String
-}
type alias Query = Hop.Types.Query

{-| A Record that represents the current location
Includes a `path` and a `query`

    {
      path: String,
      query: Query
    }
-}
type alias Location = Hop.Types.Location


{-| Hop Configuration

- basePath: Only for pushState routing (not hash). e.g. "/app". All routing and matching is done after this basepath.
- hash: True for hash routing, False for pushState routing.
- notFound: Route that will match when a location is not found.

-}
type alias Config route = Hop.Types.Config route


{-|
Create an empty Query record
-}
newQuery : Query
newQuery =
    Dict.empty

{-|
Create a empty Location record
-}
newLocation : Location
newLocation =
    { query = newQuery
    , path = []
    }

---------------------------------------
-- NORMALISE LOCATIONS
---------------------------------------

{-|
Return only the relevant part of a location string

    http://localhost:3000/app/languages?k=1 --> /app/languages?k=1
-}
toNormLocation : Config route -> String -> String
toNormLocation config href =
    let
        withoutProtocol =
            href
                |> String.split "//"
                |> List.reverse
                |> List.head
                |> Maybe.withDefault ""

        withoutDomain =
            withoutProtocol
                |> String.split "/"
                |> List.tail
                |> Maybe.withDefault []
                |> String.join "/"
                |> String.append "/"
    in
        if config.hash then
            withoutDomain
                |> String.split "#"
                |> List.drop 1
                |> List.head
                |> Maybe.withDefault ""
        else
            withoutDomain
                |> String.split "#"
                |> List.head
                |> Maybe.withDefault ""
                |> locationStringWithoutBase config

toNormPath : Config route -> String -> String
toNormPath config href =
    href
        |> toNormLocation config
        |> String.split "?"
        |> List.head
        |> Maybe.withDefault ""

{-| @priv
Remove the basePath from a location string

"/basepath/a/b?k=1" -> "/a/b?k=1"
-}
locationStringWithoutBase : Config route -> String -> String
locationStringWithoutBase config locationString =
    let
        regex =
            Regex.regex config.basePath
    in
        Regex.replace (Regex.AtMost 1) regex (always "") locationString

toLocationRecord : String -> Location
toLocationRecord =
    Hop.Location.parse

---------------------------------------
-- CREATE URLs
---------------------------------------


{-|
Make a real path from a normalised path.
This will add the hash and the basePath as necessary.

    toRealPath config "/users"

    ==

    "#/users"
-}
toRealPath : Config route -> String -> String
toRealPath config path =
    path
        |> Hop.Location.toLocation
        |> locationToRealPath config


{-|
Make a real path from a location record.
This will add the hash and the basePath as necessary.

    locationToRealPath config { path = ["users", "1"], query = Dict.empty }

    ==

    "#/users/1"

-}
locationToRealPath : Config route -> Location -> String
locationToRealPath  =
    Hop.Location.locationToRealPath



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
