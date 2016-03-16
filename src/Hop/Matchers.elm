module Hop.Matchers (match1, match2, match3, match4, nested1, nested2, int, str, matchPath, matchLocation, matcherToPath) where

{-| Functions for matching paths

# Building matchers
@docs match1, match2, match3, match4, nested1, nested2, int, str

# Using matchers
@docs matchPath, matchLocation, matcherToPath
-}

import String
import Hop.Types exposing (..)
import Hop.Url
import Combine exposing (Parser, parse)
import Combine.Num
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


parserWithBeginningAndEnd : Parser a -> Parser a
parserWithBeginningAndEnd parser =
  parser <* Combine.end


{-| Create a matcher with one static segment

  match1 Users "/users"
-}
match1 : action -> String -> PathMatcher action
match1 constructor segment1 =
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


{-| Create a matcher with one static segment and one dynamic segment

  match2 User "/users/" int
-}
match2 : (input1 -> action) -> String -> Parser input1 -> PathMatcher action
match2 constructor segment1 parser1 =
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


{-| Create a matcher with three segments.

  match3 UserStatus "/users/" int "/status"
-}
match3 : (input1 -> action) -> String -> Parser input1 -> String -> PathMatcher action
match3 constructor segment1 parser1 segment2 =
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


{-| Create a matcher with four segments.

  match4 UserStatus "/users/" int "/token/" str
-}
match4 : (input1 -> input2 -> action) -> String -> Parser input1 -> String -> Parser input2 -> PathMatcher action
match4 constructor segment1 parser1 segment2 parser2 =
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


{-| Create a matcher with two segments and nested routes

  nested1 UserComments "/user" commentRoutes
-}
nested1 : (subAction -> action) -> String -> List (PathMatcher subAction) -> PathMatcher action
nested1 constructor segment1 children =
  let
    childrenParsers =
      List.map .parser children

    parser =
      Combine.string segment1
        `Combine.andThen` (\x -> (Combine.choice childrenParsers))
        |> parserWithBeginningAndEnd
        |> Combine.map constructor
  in
    { parser = parser
    , segments = [ segment1 ]
    }


{-| Create a matcher with two segments and nested routes

  nested2 UserComments "/users/" int commentRoutes
-}
nested2 : (input1 -> subAction -> action) -> String -> Parser input1 -> List (PathMatcher subAction) -> PathMatcher action
nested2 constructor segment1 parser1 children =
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


{-| Parameter matcher that matches an integer

  match2 User "/users/" int
-}
int : Parser Int
int =
  Combine.Num.int


{-| Parameter matcher that matches a string, except /

  match2 Token "/token/" str
-}
str : Parser String
str =
  Combine.regex "[^/]+"



---------------------------------------
-- MATCHING


{-|
Matches a path e.g. "/users/1/comments/2"
Returns the matching action

  matchPath routes NotFound "/users/1/comments/2"

  ==

  User 1 (Comment 2)
-}
matchPath : List (PathMatcher action) -> action -> String -> action
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


{-|
Matches a complete location including path and query e.g. "/users/1/post?a=1"
Returns a tuple e.g. (action, query)

  matchLocation routes NotFound "/users/1?a=1"

  ==

  (User 1, Dict.singleton "a" "1")
-}
matchLocation : List (PathMatcher action) -> action -> String -> ( action, Url )
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


{-|
Generates a path from a matcher
-}
matcherToPath : PathMatcher a -> List String -> String
matcherToPath matcher inputs =
  let
    inputs' =
      List.append inputs [ "" ]

    makeSegment segment input =
      segment ++ input
  in
    List.map2 makeSegment matcher.segments inputs'
      |> String.join ""
