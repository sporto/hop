module Hop.Matcher (..) where

import String
import Hop.Types exposing (..)
import Hop.Url exposing (Query)
import Combine exposing (Parser, parse)


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



{-
matchLocation
Matchers a complete location (path + query)
Returns a tagged tuple e.g. Show (action, query)
location includes path and query e.g. "users/1/post?a=1"
-}


matchLocation : List (Route action) -> (( action, Query ) -> wrapperAction) -> action -> String -> wrapperAction
matchLocation routeParsers routingAction notFoundAction location =
  let
    url =
      Hop.Url.parse location

    matchedAction =
      matchPath routeParsers notFoundAction url.path
  in
    routingAction ( matchedAction, url.query )


routeToPath : Route a -> List String -> String
routeToPath route inputs =
  let
    makeSegment segment input =
      segment ++ input
  in
    List.map2 makeSegment route.segments inputs
      |> String.join ""
