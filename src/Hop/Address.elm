module Hop.Address exposing (..)

import Dict
import String
import Regex
import Http exposing (uriEncode, uriDecode)
import Hop.Types exposing (..)


-------------------------------------------------------------------------------
-- A real path represents the browser url without normalising for hash or path routing
-- e.g. http://example.com/#users/1?k=1

-- A normalised path represents an application path after normalising hash and basepath
-- e.g. /users/1?k=1 regardless if hash or path routing
-------------------------------------------------------------------------------









{-| @priv
Get the query string from a Address.
Including ?
-}
getQuery : Address -> String
getQuery address =
    if Dict.isEmpty address.query then
        ""
    else
        address.query
            |> Dict.toList
            |> List.map (\( k, v ) -> ( uriEncode k, uriEncode v ))
            |> List.map (\( k, v ) -> k ++ "=" ++ v)
            |> String.join "&"
            |> String.append "?"



--------------------------------------------------------------------------------
-- PARSING
-- Parse a path into a Address
--------------------------------------------------------------------------------









{-|
Convert a real path/url to a address record

- Considers path or hash routing
- Removes the basePath if necessary

    http://localhost:3000/app/languages --> { path = ..., query = .... }
-}
-- fromUrl : Config route -> String -> Address
-- fromUrl config href =
--     let
--         relevantAddressString =
--             fromUrlString config href
--     in
--         if config.hash then
--             parse relevantAddressString
--         else
--             relevantAddressString
--                 |> addressStringWithoutBase config
--                 |> parse


parse : String -> Address
parse route =
    { path = parsePath route
    , query = parseQuery route
    }


extractPath : String -> String
extractPath route =
    route
        |> String.split "#"
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""
        |> String.split "?"
        |> List.head
        |> Maybe.withDefault ""


parsePath : String -> List String
parsePath route =
    route
        |> extractPath
        |> String.split "/"
        |> List.filter (\segment -> not (String.isEmpty segment))


extractQuery : String -> String
extractQuery route =
    route
        |> String.split "?"
        |> List.drop 1
        |> List.head
        |> Maybe.withDefault ""


parseQuery : String -> Query
parseQuery route =
    route
        |> extractQuery
        |> String.split "&"
        |> List.filter (not << String.isEmpty)
        |> List.map queryKVtoTuple
        |> Dict.fromList


{-| @priv
Convert a string to a tuple. Decode on the way.

    "k=1" --> ("k", "1")
-}
queryKVtoTuple : String -> ( String, String )
queryKVtoTuple kv =
    let
        splitted =
            kv
                |> String.split "="

        first =
            splitted
                |> List.head
                |> Maybe.withDefault ""

        firstDecoded =
            uriDecode first

        second =
            splitted
                |> List.drop 1
                |> List.head
                |> Maybe.withDefault ""

        secondDecoded =
            uriDecode second
    in
        ( firstDecoded, secondDecoded )
