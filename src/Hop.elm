module Hop
    exposing
        ( addQuery
        , clearQuery
        , ingest
        , makeResolver
        , output
        , outputFromPath
        , pathFromAddress
        , queryFromAddress
        , removeQuery
        , setQuery
        )

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Consuming an URL from the browser
@docs ingest, makeResolver

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
`makeResolver` normalizes the URL using your config and then gives that normalised URL to your parser.

Use this for creating a function to give to `Navigation.makeParser`. 
See examples in `docs/matching-routes.md`.

    Hop.makeResolver hopConfig parse

`makeResolver` takes 2 arguments.

### Config e.g.

    { basePath = ""
    , hash = False
    }

### Parse function

A function that receives the normalised path and returns the result of parsing it.

    parse path =
        path
            |> UrlParser.parse identity routes
            |> Result.withDefault NotFoundRoute

You parse function will receive the path like this:

`http://example.com/users/1` --> 'users/1/'

So it won't have a leading /, but it will have a trailing /. This is because the way UrlParse works.

### Return value from resolver

After being called with a URL the resolver will return a tuple with `(parse result, address)` e.g.

    resolver =
        Hop.makeResolver hopConfig parse

    resolver "http://example.com/index.html#/users/2"

    -->

    ( UserRoute 2, { path = ["users", "2"], query = ...} )

### Example

A complete example looks like:

    urlParser : Navigation.Parser ( Route, Address )
    urlParser =
        let
            parse path =
                path
                    |> UrlParser.parse identity routes
                    |> Result.withDefault NotFoundRoute

            resolver =
                Hop.makeResolver hopConfig parse
        in
            Navigation.makeParser (.href >> resolver)

-}
makeResolver :
    Config
    -> (String -> result)
    -> String
    -> (result, Address)
makeResolver config parse rawInput =
    let
        address =
            rawInput
                |> ingest config

        parseResult =
            pathFromAddress address
                ++ "/"
                |> String.dropLeft 1
                |> parse
    in
        (parseResult, address)



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
    Hop.Address.getQuery



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
