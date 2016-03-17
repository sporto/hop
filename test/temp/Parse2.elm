module Parse2 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- Having a parses try to get a tag


type Route
  = Route1 Int Int
  | NotFound


path =
  "/posts/11/comments/22"


allParsers =
  string "/posts/"
    *> int
    `andThen` (\r -> map (\x -> ( r, x )) (string "/comments/" *> int <* end))


parseResult =
  parse allParsers path


result =
  case parseResult of
    ( Ok ( a, b ), context ) ->
      Route1 a b

    ( Err _, context ) ->
      NotFound


main =
  text (toString result)
