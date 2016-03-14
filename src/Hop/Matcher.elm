module Hop.Matcher (..) where

import String
import Hop.Types exposing (..)
import Hop.Url
import Combine exposing (Parser, parse)


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


matchPathWithQuery routingAction notFoundAction fullPath routeParsers =
  let
    url =
      Hop.Url.parse fullPath

    path =
      "/" ++ url.path
  in
    routingAction ( matchPath notFoundAction path routeParsers, url.query )


routeToPath : Route a -> List String -> String
routeToPath route inputs =
  let
    makeSegment segment input =
      segment ++ input
  in
    List.map2 makeSegment route.segments inputs
      |> String.join ""
