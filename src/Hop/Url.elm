module Hop.Url (..) where

import Dict
import String
import Http
import Hop.Types exposing (..)


newQuery : Query
newQuery =
  Dict.empty


newUrl : Url
newUrl =
  { query = newQuery
  , path = []
  }



-------------------------------------------------------------------------------
{-
urlToLocation
Given a Url.
Generate a location path.
e.g. url -> "#/users/1?a=1"
-}


urlToLocation : Url -> String
urlToLocation url =
  let
    path' =
      String.join "/" url.path
  in
    "#/" ++ path' ++ (queryFromUrl url)



-- Normalize a location from user


urlFromUser : String -> Url
urlFromUser route =
  let
    normalized =
      if String.startsWith "#" route then
        route
      else
        "#" ++ route
  in
    parse normalized



{-
queryFromUrl
Get the query string from an Url.
Including ?
-}


queryFromUrl : Url -> String
queryFromUrl url =
  if Dict.isEmpty url.query then
    ""
  else
    url.query
      |> Dict.toList
      |> List.map (\( k, v ) -> k ++ "=" ++ v)
      |> String.join "&"
      |> String.append "?"



-------------------------------------------------------------------------------
-- PARSING
-- Parse a route into a Url


parse : String -> Url
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


addQuery : Query -> Url -> Url
addQuery query url =
  let
    updatedQuery =
      Dict.union query url.query
  in
    { url | query = updatedQuery }


setQuery : Query -> Url -> Url
setQuery query url =
  { url | query = query }


removeQuery : String -> Url -> Url
removeQuery key url =
  let
    updatedQuery =
      Dict.remove key url.query
  in
    { url | query = updatedQuery }


clearQuery : Url -> Url
clearQuery url =
  { url | query = Dict.empty }
