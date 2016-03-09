module Parse5 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- TODO
-- SubRoutes
-- Reverse routing
-- Query
--
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


type CommentRoutes
  = Comments ()
  | Comment (Int)


type UserRoute
  = Route1 ( Int, Int )
  | Post (Int)
  | PostComments ( Int, CommentRoutes )
  | NotFound ()


parserRoute1 =
  string "posts/"
    *> int
    `andThen` (\r -> map (\x -> ( r, x )) (string "/comments/" *> int))


routeRoute1 =
  route Route1 parserRoute1


parserPost =
  string "posts/"
    *> int


routePost =
  route Post parserPost


parserPostComments =
  string "posts/"
    *> int
    `andThen` (\r -> map (\x -> ( r, x )) routeComment)


routePostComments =
  route PostComments parserPostComments


routeComments =
  route Comments parserComments


parseComment =
  string "comments/"
    *> int


routeComment =
  route Comment parseComment


parserComments =
  string "/comments"
    |> map (\r -> ())


commentRoutes =
  [ routeComments, routeComment ]


routes =
  [ routePost, routePostComments ]


path1 =
  "/posts/11/comments/22"


path2 =
  "/posts/11"


result =
  matchPath path1 routes


main =
  text (toString result)
