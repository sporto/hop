module Hop
    exposing
        ( ingest
        , pathFromAddress
        , output
        , outputFromPath
        , addQuery
        , setQuery
        , removeQuery
        , clearQuery
        )

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Inbound URLs
@docs ingest

# Outbound URLs
@docs output, outputFromPath

# Work with an Address record
@docs pathFromAddress

# Change query string
@docs addQuery, setQuery, removeQuery, clearQuery

-}

import Dict
import Hop.Address
import Hop.In
import Hop.Out
import Hop.Types exposing (Address, Config, Query)


---------------------------------------
-- INGEST
---------------------------------------


{-|
Convert a raw url to an Address record
This conversion will take in account your basePath and hash configuration 

E.g. with path routing

    ingest config "http://localhost:3000/app/languages/1?k=1" 
    -->
    { path = ["app", "languages", "1" ], query = Dict.singleton "k" "1" }

E.g. with hash routing

    ingest config "http://localhost:3000/app#/languages/1?k=1" 
    -->
    { path = ["languages", "1" ], query = Dict.singleton "k" "1" }
-}
ingest : Config -> String -> Address
ingest =
    Hop.In.ingest



---------------------------------------
-- CREATE OUTBOUND URLs
---------------------------------------


{-|
Convert an Address record to a URL to feed the browser
This will take in account your basePath and hash config

E.g. with path routing

    output config { path = ["languages", "1" ], query = Dict.singleton "k" "1" }
    -->
    "/languages/1?k=1"

E.g. with hash routing

    output config { path = ["languages", "1" ], query = Dict.singleton "k" "1" }
    -->
    "#/languages/1?k=1"
-}
output : Config -> Address -> String
output =
    Hop.Out.output


{-|
Convert a string to a URL to feed the browser
This will take in account your basePath and hash config

E.g. with path routing

    outputFromPath config "/languages/1?k=1"
    -->
    "/languages/1?k=1"

E.g. with path + basePath routing

    outputFromPath config "/languages/1?k=1"
    -->
    "/app/languages/1?k=1"

E.g. with hash routing

    output config "/languages/1?k=1"
    -->
    "#/languages/1?k=1"
-}
outputFromPath : Config -> String -> String
outputFromPath =
    Hop.Out.outputFromPath



---------------------------------------
-- WORK WITH ADDRESS
---------------------------------------


{-|
Get the path as a string from an Address record

    

-}
pathFromAddress : Address -> String
pathFromAddress =
    Hop.Address.getPath



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
addQuery : Query -> Address -> Address
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
setQuery : Query -> Address -> Address
setQuery query location =
    { location | query = query }


{-|
Remove one key from the query string

    removeQuery key location
-}
removeQuery : String -> Address -> Address
removeQuery key location =
    let
        updatedQuery =
            Dict.remove key location.query
    in
        { location | query = updatedQuery }


{-| Clear all query string values

    clearQuery location
-}
clearQuery : Address -> Address
clearQuery location =
    { location | query = Dict.empty }
