module Parse2 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- Having a parses try to get a tag


type Route
  = Route1 Int Int
  | NotFound


path1 =
  "/posts/11/comments/22"


parser1 =
  string "/posts/"
    *> int
    `andThen` (\r -> map (\x -> ( r, x )) (string "/comments/" *> int <* end))



-- this needs to be generic
-- remove the tuple (a, b), just have a b
-- unless action take tuples


possibleParsers =
  [ ( Route1, parser1 ) ]



-- Loop through the list of parsers here
-- Call the makeRoute for the appropiate one
-- Check if one parser matches
-- if it does then return Ok params


matchParser path parser =
  let
    result =
      parse parser path
  in
    case result of
      ( Ok ( a, b ), context ) ->
        (Ok ( a, b ))

      ( Err _, context ) ->
        (Err ())


matchPath path parsers =
  case parsers of
    [] ->
      NotFound

    [ ( routeConstructor, parser ) ] ->
      case matchParser path parser of
        Ok ( a, b ) ->
          routeConstructor a b

        Err _ ->
          NotFound

    ( routeConstructor, parser ) :: rest ->
      case matchParser path parser of
        Ok ( a, b ) ->
          routeConstructor a b

        Err _ ->
          matchPath path rest


result =
  matchPath path1 possibleParsers


main =
  text (toString result)
