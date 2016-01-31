module Hop.Url where

import Hop.Types as Types
import Dict
import String
import Http

{-
Url
- parsing of route into Url record 
- manipulation of Url record
-}

-- URL TO ROUTE STRING

-- Get route from Url
routeFromUrl : Types.Url -> String
routeFromUrl url =
  "#/" ++ (pathFromUrl url) ++ (queryFromUrl url)
  
-- query just the query including ?
queryFromUrl : Types.Url -> String
queryFromUrl url =
  if Dict.isEmpty url.query then
    ""
   else
     url.query
      |> Dict.toList
      |> List.map (\(k,v) -> k ++ "=" ++ v)
      |> String.join "&"
      |> String.append "?"
      
pathFromUrl : Types.Url -> String
pathFromUrl url =
  if List.isEmpty url.path then
    ""
  else
    url.path
      |> String.join "/"

-- PARSE

-- Parse a route into a Url

parse : String -> Types.Url
parse route =
  {
    path = parsePath route,
    query = parseQuery route
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

parsePath : String -> Types.Path
parsePath route =
  route
    |> extractPath
    |> String.split "/"
    |> List.filter (not << String.isEmpty)

extractQuery : String -> String
extractQuery route =
  route
    |> String.split "?"
    |> List.drop 1
    |> List.head
    |> Maybe.withDefault ""
    
parseQuery : String -> Types.Query
parseQuery route =
  route
    |> extractQuery
    |> String.split "&"
    |> List.filter (not << String.isEmpty)
    |> List.map queryKVtoTuple
    |> Dict.fromList

queryKVtoTuple : String -> (String, String)
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
    (firstDecoded, secondDecoded)

-- PARSE ROUTE GIVEN BY USER

urlFromUser : String -> Types.Url
urlFromUser route =
  let
    normalized =
      if String.startsWith "#" route then
        route
      else
        "#" ++ route
  in
    parse normalized

-- MUTATE QUERY

addQuery : Types.Query -> Types.Url -> Types.Url
addQuery query url =
  let
    updatedQuery =
      Dict.union query url.query
  in
    {url | query = updatedQuery}

setQuery : Types.Query -> Types.Url -> Types.Url
setQuery query url =
  {url | query = query }

removeQuery : String -> Types.Url -> Types.Url
removeQuery key url = 
  let
    updatedQuery =
      Dict.remove key url.query
  in
    { url | query = updatedQuery}
    
clearQuery : Types.Url -> Types.Url
clearQuery url =
  {url | query = Dict.empty }
