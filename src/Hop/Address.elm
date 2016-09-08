module Hop.Address exposing (..)

import Dict
import String
import Http exposing (uriEncode, uriDecode)
import Hop.Types exposing (..)

{-|
Get the Path
-}
getPath : Address -> String
getPath address =
    address.path
        |> List.map uriEncode
        |> String.join "/"
        |> String.append "/"


{-|
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
        |> List.map uriDecode


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
