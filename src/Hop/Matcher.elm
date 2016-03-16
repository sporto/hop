module Hop.Matcher (matchPath, matchLocation, routeToPath) where

{-| Functions for matching routes

@docs matchPath, matchLocation, routeToPath
-}

import String
import Hop.Types exposing (..)
import Hop.Url
import Combine exposing (Parser, parse)


{-| matchPath
Matches a path e.g. "/users/1/comments/2"
Returns the matching action

  matchPath routes NotFound "/users/1/comments/2"

  ==

  User 1 (Comment 2)
-}
matchPath : List (Route action) -> action -> String -> action
matchPath routeParsers notFoundAction path =
  case routeParsers of
    [] ->
      notFoundAction

    [ routeParser ] ->
      case parse routeParser.parser path of
        ( Ok res, context ) ->
          res

        ( Err _, context ) ->
          notFoundAction

    routeParser :: rest ->
      case parse routeParser.parser path of
        ( Ok res, context ) ->
          res

        ( Err _, context ) ->
          matchPath rest notFoundAction path


{-| matchLocation
Matches a complete location including path and query e.g. "/users/1/post?a=1"
Returns a tuple e.g. (action, query)

  matchLocation routes NotFound "/users/1?a=1"

  ==

  (User 1, Dict.singleton "a" "1")
-}
matchLocation : List (Route action) -> action -> String -> ( action, Url )
matchLocation routeParsers notFoundAction location =
  let
    url =
      Hop.Url.parse location

    path =
      "/" ++ (String.join "/" url.path)

    matchedAction =
      matchPath routeParsers notFoundAction path
  in
    ( matchedAction, url )


{-| Create a path from a route
-}
routeToPath : Route a -> List String -> String
routeToPath route inputs =
  let
    inputs' =
      List.append inputs [ "" ]

    makeSegment segment input =
      segment ++ input
  in
    List.map2 makeSegment route.segments inputs'
      |> String.join ""
