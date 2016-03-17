module Hop.Matchers (match1, match2, match3, match4, nested1, nested2, int, str, matchPath, matchLocation, matcherToPath) where

{-|
Functions for building matchers and matching paths

# Building matchers
@docs match1, match2, match3, match4, nested1, nested2, int, str

# Using matchers
@docs matchPath, matchLocation, matcherToPath
-}

import String
import Hop.Types exposing (..)
import Hop.Location
import Combine exposing (Parser, parse)
import Combine.Num
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


parserWithBeginningAndEnd : Parser a -> Parser a
parserWithBeginningAndEnd parser =
  parser <* Combine.end


{-|
Create a matcher with one static segment.

    match1 Users "/users"

This will match exactly

    "/user"
-}
match1 : route -> String -> PathMatcher route
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


{-|
Create a matcher with one static segment and one dynamic parameter.

    match2 User "/tokens/" str

This will match a path like

    "/tokens/abc"
-}
match2 : (param1 -> route) -> String -> Parser param1 -> PathMatcher route
match2 constructor segment1 parser1 =
  let
    parser =
      Combine.string segment1
        *> parser1
        |> parserWithBeginningAndEnd
        |> Combine.map constructor
  in
    { parser = parser
    , segments = [ segment1 ]
    }


{-| Create a matcher with three segments.

    match3 UserStatus "/users/" int "/status"

This will match a path like

    "/users/1/status"
-}
match3 : (param1 -> route) -> String -> Parser param1 -> String -> PathMatcher route
match3 constructor segment1 parser1 segment2 =
  let
    parser =
      Combine.string segment1
        *> parser1
        <* Combine.string segment2
        |> parserWithBeginningAndEnd
        |> Combine.map constructor
  in
    { parser = parser
    , segments = [ segment1, segment2 ]
    }


{-| Create a matcher with four segments.

    match4 UserToken "/users/" int "/token/" str

This will match a path like

    "/users/1/token/abc"

-}
match4 : (param1 -> param2 -> route) -> String -> Parser param1 -> String -> Parser param2 -> PathMatcher route
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

    nested1 ShopCategories "/shop" categoriesRoutes

This could match paths like (depending on the nested routes)

    "/shop/games"
    "/shop/business"
    "/shop/product/1"
    "/shop/.."

-}
nested1 : (subRoute -> route) -> String -> List (PathMatcher subRoute) -> PathMatcher route
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

This could match paths like (depending on the nested routes)

    "/users/1/comments"
    "/users/1/comments/3"

-}
nested2 : (param1 -> subRoute -> route) -> String -> Parser param1 -> List (PathMatcher subRoute) -> PathMatcher route
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
Returns the matching route

  matchPath routes NotFound "/users/1/comments/2"

  ==

  User 1 (Comment 2)
-}
matchPath : List (PathMatcher route) -> route -> String -> route
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
Returns a tuple e.g. (route, query)

  matchLocation routes NotFound "/users/1?a=1"

  ==

  (User 1, Dict.singleton "a" "1")
-}
matchLocation : List (PathMatcher route) -> route -> String -> ( route, Location )
matchLocation routeParsers notFoundAction location =
  let
    url =
      Hop.Location.parse location

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
