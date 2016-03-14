module Hop.Builder (..) where

import Hop.Types exposing (..)
import Combine exposing (Parser)
import Combine.Num
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


{-
Builder takes care of building routes and parsers
-}


parserWithBeginningAndEnd : Parser a -> Parser a
parserWithBeginningAndEnd parser =
  parser <* Combine.end


route1 : action -> String -> Route action
route1 constructor segment1 =
  let
    parser =
      Combine.string segment1
        |> Combine.skip
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'

    constructor' =
      (\() -> constructor)
  in
    { parser = parser
    , segments = [ segment1 ]
    }


route2 : (input1 -> action) -> String -> Parser input1 -> Route action
route2 constructor segment1 parser1 =
  let
    constructor' input1 =
      constructor input1

    parser =
      Combine.string segment1
        *> parser1
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1 ]
    }


route3 : (input1 -> action) -> String -> Parser input1 -> String -> Route action
route3 constructor segment1 parser1 segment2 =
  let
    constructor' input1 =
      constructor input1

    parser =
      Combine.string segment1
        *> parser1
        <* Combine.string segment2
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1, segment2 ]
    }


route4 : (input1 -> input2 -> action) -> String -> Parser input1 -> String -> Parser input2 -> Route action
route4 constructor segment1 parser1 segment2 parser2 =
  let
    constructor' ( a, b ) =
      constructor a b

    parser =
      Combine.string segment1
        *> parser1
        `Combine.andThen` (\r -> Combine.map (\x -> ( r, x )) (Combine.string segment2 *> parser2))
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1, segment2 ]
    }


nestedRoutes1 : (input1 -> subAction -> action) -> String -> Parser input1 -> List (Route subAction) -> Route action
nestedRoutes1 constructor segment1 parser1 children =
  let
    childrenParsers =
      List.map .parser children

    constructor' ( a, b ) =
      constructor a b

    parser =
      Combine.string segment1
        *> parser1
        `Combine.andThen` (\r -> Combine.map (\x -> ( r, x )) (Combine.choice childrenParsers))
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1 ]
    }


int =
  Combine.Num.int


str =
  Combine.regex "[^/]+"
