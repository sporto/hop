module Hop
    exposing
        ( ingest
        , pathFromAddress
        , outgest
        , outgestFromPath
        , addQuery
        , setQuery
        , removeQuery
        , clearQuery
        )

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Types
@docs Config, Address, Query

# Normalise URLs
@docs ingest

# Create URLs
@docs outgest, outgestFromPath

# Manipulate Address
@docs pathFromAddress

# Change query string
@docs addQuery, setQuery, removeQuery, clearQuery

-}

import String
import Dict
import Hop.Types exposing (Address, Query)
import Hop.Address
import Hop.In
import Hop.Out
import Regex


---------------------------------------
-- INGEST
---------------------------------------


{-|
Return only the relevant part of a location string depending on the configuration

    http://localhost:3000/app/languages?k=1 --> /app/languages?k=1
-}
ingest =
    Hop.In.ingest

---------------------------------------
-- CREATE OUTBOUND URLs
---------------------------------------

outgest =
    Hop.Out.outgest

outgestFromPath =
    Hop.Out.outgestFromPath


---------------------------------------
-- WORK WITH ADDRESS
---------------------------------------


pathFromAddress : Address -> String
pathFromAddress address =
    address.path
        |> String.join "/"



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
addQuery : Query -> Hop.Types.Address -> Hop.Types.Address
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
setQuery : Query -> Hop.Types.Address -> Hop.Types.Address
setQuery query location =
    { location | query = query }


{-|
Remove one key from the query string

    removeQuery key location
-}
removeQuery : String -> Hop.Types.Address -> Hop.Types.Address
removeQuery key location =
    let
        updatedQuery =
            Dict.remove key location.query
    in
        { location | query = updatedQuery }


{-| Clear all query string values

    clearQuery location
-}
clearQuery : Hop.Types.Address -> Hop.Types.Address
clearQuery location =
    { location | query = Dict.empty }
