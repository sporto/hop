module Hop
    exposing
        ( addQuery
        , clearQuery
        , ingest
        , makeMatcher
        , output
        , outputFromPath
        , pathFromAddress
        , queryFromAddress
        , removeQuery
        , setQuery
        )

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Consuming an URL from the browser
@docs ingest, makeMatcher

# Preparing a URL for changing the browser location
@docs output, outputFromPath

# Work with an Address record
@docs pathFromAddress, queryFromAddress

# Modify the query string
@docs addQuery, setQuery, removeQuery, clearQuery

-}

import Dict
import String
import Hop.Address
import Hop.In
import Hop.Out
import Hop.Types exposing (Address, Config, Query)


---------------------------------------
-- INGEST
---------------------------------------


{-|
Convert a raw url to an Address record. Use this function for 'normalizing' the URL before parsing it.
This conversion will take in account your basePath and hash configuration.

E.g. with path routing

    config =
        { basePath = ""
        , hash = False
        }

    ingest config "http://localhost:3000/app/languages/1?k=1"
    -->
    { path = ["app", "languages", "1" ], query = Dict.singleton "k" "1" }

E.g. with path routing and base path

    config =
        { basePath = "/app/v1"
        , hash = False
        }

    ingest config "http://localhost:3000/app/v1/languages/1?k=1"
    -->
    { path = ["languages", "1" ], query = Dict.singleton "k" "1" }

E.g. with hash routing

    config =
        { basePath = ""
        , hash = True
        }

    ingest config "http://localhost:3000/app#/languages/1?k=1"
    -->
    { path = ["languages", "1" ], query = Dict.singleton "k" "1" }
-}
ingest : Config -> String -> Address
ingest =
    Hop.In.ingest


{-|
makeMatcher is a convenient function to help extracting, parsing and formating
the output from the Navigation module

Use this for creating a function to give to `Navigation.makeParser`. See example in matching documentation.

makeMatcher takes 4 arguments.

### Config e.g.

    { basePath = ""
    , hash = False
    }

### Extract function

A function that extracts the url for parsing e.g.

    .href

### Parse function

A function that receives the normalised path and returns the result of parsing it.

    parse path =
        path
            |> UrlParser.parse identity routes
            |> Result.withDefault NotFoundRoute

### Format function

A function that receives the parsed result and an Address record.
This function returns the final output to feed to the application. 

e.g.

    (,)

A complete example looks like:

    urlParser : Navigation.Parser ( Route, Address )
    urlParser =
        let
            parse path =
                path
                    |> UrlParser.parse identity routes
                    |> Result.withDefault NotFoundRoute

            matcher =
                Hop.makeMatcher hopConfig .href parse (,)
        in
            Navigation.makeParser matcher

-}
makeMatcher :
    Config
    -> (url -> String)
    -> (String -> result)
    -> (result -> Address -> formatted)
    -> url
    -> formatted
makeMatcher config extract parse format rawInput =
    let
        address =
            rawInput
                |> extract
                |> ingest config

        parseResult =
            pathFromAddress address
                ++ "/"
                |> String.dropLeft 1
                |> parse
    in
        format parseResult address



---------------------------------------
-- CREATE OUTBOUND URLs
---------------------------------------


{-|
Convert an Address record to an URL to feed the browser.
This will take in account your basePath and hash config.

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
Convert a string to an URL to feed the browser.
This will take in account your basePath and hash config.

E.g. with path routing

    outputFromPath config "/languages/1?k=1"
    -->
    "/languages/1?k=1"

E.g. with path routing + basePath

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
Get the path as a string from an Address record.

    address = { path = ["languages", "1" ], query = Dict.singleton "k" "1" }

    pathFromAddress address
    -->
    "/languages/1"
-}
pathFromAddress : Address -> String
pathFromAddress =
    Hop.Address.getPath


{-|
Get the query as a string from an Address record.

    address = { path = ["app"], query = Dict.singleton "k" "1" }

    queryFromAddress address
    -->
    "?k=1"
-}
queryFromAddress : Address -> String
queryFromAddress =
    Hop.Address.getPath



-------------------------------------------------------------------------------
-- QUERY MUTATION
-------------------------------------------------------------------------------


{-|
Add query string values (patches any existing values) to an Address record.

    addQuery query address

    addQuery (Dict.Singleton "b" "2") { path = [], query = Dict.fromList [("a", "1")] }

    ==

    { path = [], query = Dict.fromList [("a", "1"), ("b", "2")] }

- query is a dictionary with keys to add

To remove a key / value pair set the value to ""
-}
addQuery : Query -> Address -> Address
addQuery query location =
    let
        updatedQuery =
            Dict.union query location.query
    in
        { location | query = updatedQuery }


{-|
Set the whole query string (removes any existing values).

    setQuery query address
-}
setQuery : Query -> Address -> Address
setQuery query location =
    { location | query = query }


{-|
Remove one key from the query string

    removeQuery key address
-}
removeQuery : String -> Address -> Address
removeQuery key location =
    let
        updatedQuery =
            Dict.remove key location.query
    in
        { location | query = updatedQuery }


{-| Clear all query string values

    clearQuery address
-}
clearQuery : Address -> Address
clearQuery location =
    { location | query = Dict.empty }
