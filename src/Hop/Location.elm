module Hop.Location (..) where

import Dict
import String
import Http
import Hop.Types exposing (..)


-------------------------------------------------------------------------------


{-|
Given a Location.
Generate a full path.
e.g. location -> "#/users/1?a=1"
-}



-- was urlToLocation


locationToFullPath : Location -> String
locationToFullPath location =
  let
    path' =
      String.join "/" location.path
  in
    "#/" ++ path' ++ (queryFromLocation location)



-- Normalize a location from user


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


{-|
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



-------------------------------------------------------------------------------
-- PARSING
-- Parse a route into a Location


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
