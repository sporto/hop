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

    type Route = Books

    match1 Books "/books"

This will match exactly

    "/books"
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

    type Route = Book Str

    match2 Book "/books/" str

This will match a path like

    "/books/abc"
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

    type Route = BookReviews Int

    match3 BookReviews "/books/" int "/reviews"

This will match a path like

    "/books/1/reviews"
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

    type Route = BookChapter Int String

    match4 BookChapter "/books/" int "/chapters/" str

This will match a path like

    "/books/1/chapters/abc"

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

    type CategoriesRoute = Games | Business | Product Int
    type Route = ShopCategories CategoriesRoute

    nested1 ShopCategories "/shop" categoriesRoutes

This could match paths like (depending on the nested routes)

    "/shop/games"
    "/shop/business"
    "/shop/product/1"

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

    type ReviewsRoutes = Reviews | Review Int
    type Route = BookReviews ReviewsRoutes

    nested2 BookReviews "/books/" int reviewsRoutes

This could match paths like (depending on the nested routes)

    "/books/1/reviews"
    "/books/1/reviews/3"

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
Matches a path e.g. "/users/1/comments/2".
Returns the matching route.

    matchPath matchers NotFound "/users/1/comments/2"

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
Matches a complete location including path and query e.g. "/users/1/post?a=1".
Returns a tuple e.g. (route, location).

    matchLocation matchers NotFound "/users/1?a=1"

    ==

    (User 1, location)
-}
matchLocation : List (PathMatcher route) -> route -> String -> ( route, Location )
matchLocation routeParsers notFoundAction pathWithQuery =
  let
    location =
      Hop.Location.parse pathWithQuery

    path =
      "/" ++ (String.join "/" location.path)

    matchedAction =
      matchPath routeParsers notFoundAction path
  in
    ( matchedAction, location )


{-|
Generates a path from a matcher.
The second parameters should be a list of strings.
You need to pass one string for each dynamic parameter that this route takes.

    matcherToPath bookReviewMatcher ["1", "2"]

    ==

    "/books/1/reviews/2"
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
