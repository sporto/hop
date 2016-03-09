module Parse4 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- LIB
--type alias RouteComponent a =
--  { parser : Parser a
--  }
--type Route a
--  = Route (RouteComponent a)


type alias Route inputs res =
  { parser : Parser inputs
  , constructor : inputs -> res
  }


route : (inputs -> res) -> Parser inputs -> Route inputs res
route constructor parser =
  let
    parserWithBeginningAndEnd =
      (Combine.string "/" *> parser <* Combine.end)
  in
    Route parserWithBeginningAndEnd constructor



--prefix : String -> RouteComponent res -> RouteComponent res
--prefix s r =
--  { parser = Combine.string (s ++ "/") *> r.parser
--  }


matchRoute route path =
  parse (map route.constructor route.parser) path



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
  string "post/"
    *> int


path1 =
  "/posts/11/comments/22"


route1 =
  route Route1 parserRoute1


route2 =
  route Post parserPost



--routes =
--  [ route1, route2 ]


result =
  matchRoute route1 path1


main =
  text (toString result)
