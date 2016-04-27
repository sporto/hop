module Hop.Location (..) where

import Dict
import String
import Regex
import Http
import Hop.Types exposing (..)


-------------------------------------------------------------------------------


{-| @priv
Given a Location generate a full path.
Used for navigation.
e.g. location -> "#/users/1?a=1" when using hash
-}
locationToFullPath : Config route -> Location -> String
locationToFullPath config location =
  let
    path' =
      if config.hash then
        location.path
      else
        config.basePath :: location.path

    joined =
      String.join "/" path'

    query =
      queryFromLocation location

    prefix =
      if config.hash then
        "#/"
      else
        ""

    dedupSlash =
      Regex.replace Regex.All (Regex.regex "/+") (\_ -> "/")
  in
    dedupSlash <| prefix ++ joined ++ query


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
hrefToLocationString : Config route -> String -> String
hrefToLocationString config href =
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
hrefToLocation : Config route -> String -> Location
hrefToLocation config href =
  let
    relevantLocationString =
      hrefToLocationString config href
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
      Http.uriDecode first

    second =
      splitted
        |> List.drop 1
        |> List.head
        |> Maybe.withDefault ""

    secondDecoded =
      Http.uriDecode second
  in
    ( firstDecoded, secondDecoded )



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


setQuery : Query -> Location -> Location
setQuery query location =
  { location | query = query }


removeQuery : String -> Location -> Location
removeQuery key location =
  let
    updatedQuery =
      Dict.remove key location.query
  in
    { location | query = updatedQuery }


clearQuery : Location -> Location
clearQuery location =
  { location | query = Dict.empty }
