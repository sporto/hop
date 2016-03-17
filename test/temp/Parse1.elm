module Parse1 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- THIS WORKS


path =
  "/posts/11/comments/22"


parserPosts =
  string "/posts/"


parserPostId =
  int


parserComments =
  string "/comments/"


parsersCommentId =
  int


allParsers =
  parserPosts
    *> int
    `andThen` (\r -> map (\x -> ( r, x )) (parserComments *> int <* end))


result =
  parse allParsers path


main =
  text (toString result)
