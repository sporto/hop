module Hop.Location exposing (..)

import Dict
import String
import Regex
import Http exposing (uriEncode, uriDecode)
import Hop.Types exposing (..)


-------------------------------------------------------------------------------


dedupSlash : String -> String
dedupSlash =
    Regex.replace Regex.All (Regex.regex "/+") (\_ -> "/")


{-| @priv
Given a Location generate a full path. Used for navigation.
e.g. location -> "#/users/1?a=1" when using hash
-}
locationToFullPath : Config route -> Location -> String
locationToFullPath config location =
    let
        joined =
            String.join "/" location.path

        query =
            queryFromLocation location

        url =
            if config.hash then
                "#/" ++ joined ++ query
            else if String.isEmpty config.basePath then
                "/" ++ joined ++ query
            else if String.isEmpty joined then
                "/" ++ config.basePath ++ query
            else
                "/" ++ config.basePath ++ "/" ++ joined ++ query
    in
        dedupSlash url


locationFromUser : String -> Location
locationFromUser route =
    let
        normalized =
            if String.startsWith "#" route then
                route
            else
                "#" ++ route
    in
        parse normalized


{-| @priv
Get the query string from a Location.
Including ?
-}
queryFromLocation : Location -> String
queryFromLocation location =
    if Dict.isEmpty location.query then
        ""
    else
        location.query
            |> Dict.toList
            |> List.map (\( k, v ) -> ( uriEncode k, uriEncode v ))
            |> List.map (\( k, v ) -> k ++ "=" ++ v)
            |> String.join "&"
            |> String.append "?"



--------------------------------------------------------------------------------
-- PARSING
-- Parse a path into a Location
--------------------------------------------------------------------------------


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


{-| @priv
Return only the relevant part of a location string

    http://localhost:3000/app/languages --> /app/languages
-}
fromUrlString : Config route -> String -> String
fromUrlString config href =
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


{-|
Convert a full url to a location

- Considers path or hash routing
- Removes the basePath if necessary

    http://localhost:3000/app/languages --> { path = ..., query = .... }
-}
fromUrl : Config route -> String -> Location
fromUrl config href =
    let
        relevantLocationString =
            fromUrlString config href
    in
        if config.hash then
            parse relevantLocationString
        else
            relevantLocationString
                |> locationStringWithoutBase config
                |> parse


parse : String -> Location
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
