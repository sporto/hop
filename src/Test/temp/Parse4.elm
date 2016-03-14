module Parse4 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- LIB


route : (inputs -> res) -> Parser inputs -> Parser res
route constructor parser =
  let
    parserWithBeginningAndEnd =
      (Combine.string "/" *> parser <* Combine.end)
  in
    map constructor parserWithBeginningAndEnd


matchPath path routeParsers =
  case routeParsers of
    [] ->
      (Err NotFound)

    [ routeParser ] ->
      case parse routeParser path of
        ( Ok res, context ) ->
          (Ok res)

        ( Err _, context ) ->
          (Err NotFound)

    routeParser :: rest ->
      case parse routeParser path of
        ( Ok res, context ) ->
          (Ok res)

        ( Err _, context ) ->
          matchPath path rest



-- USER


type UserRoute
  = Route1 ( Int, Int )
  | Post (Int)
  | NotFound


parserRoute1 =
  string "posts/"
    *> int
    `andThen` (\r -> map (\x -> ( r, x )) (string "/comments/" *> int))


parserPost =
  string "posts/"
    *> int


path1 =
  "/posts/11/comments/22"


path2 =
  "/posts/11"


route1 =
  route Route1 parserRoute1


route2 =
  route Post parserPost


routes =
  [ route1, route2 ]


result =
  matchPath path2 routes


main =
  text (toString result)
