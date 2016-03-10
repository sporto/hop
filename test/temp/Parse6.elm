module Parse6 (..) where

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


route1 : (() -> a) -> String -> Parser a
route1 constructor segment =
  let
    parser =
      string segment
        |> map (\r -> ())
  in
    route constructor parser


route2 : (inputs -> a) -> String -> Parser inputs -> Parser a
route2 constructor segment parser1 =
  let
    parser =
      string segment
        *> parser1
  in
    route constructor parser


nestedRoutes1 : (( inputs, subInputs ) -> action) -> String -> Parser inputs -> List (Parser subInputs) -> Parser action
nestedRoutes1 constructor segment parser1 children =
  let
    parser =
      string segment
        *> parser1
        `andThen` (\r -> map (\x -> ( r, x )) (choice children))
  in
    route constructor parser


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


reverse action routeParser =
  "hello"



-- USER


type CommentRoutes
  = Comments ()
  | Comment (Int)


type UserRoute
  = Posts ()
  | Post (Int)
  | PostUser ( Int, Int )
  | PostComments ( Int, CommentRoutes )
  | NotFound


parserPostUser =
  string "posts/"
    *> int
    `andThen` (\r -> map (\x -> ( r, x )) (string "/users/" *> int))


routePostUser =
  route PostUser parserPostUser



--parserPosts =
--  string "posts"
--    |> map (\r -> ())
{- TODO combine route and parserPost in one thing

  route1 Posts "posts"

Or maybe two:

  route Posts (path1 "posts")
-}
--routePosts =
--  route Posts parserPosts


routePosts =
  route1 Posts "posts"



--parserPost =
--  string "posts/"
--    *> int
--routePost =
--  route Post parserPost


routePost =
  route2 Post "posts/" int



--parserPostComments =
--  string "posts/"
--    *> int
--    `andThen` (\r -> map (\x -> ( r, x )) (choice commentRoutes))
--routePostComments =
--  route PostComments parserPostComments


routePostComments =
  nestedRoutes1 PostComments "posts/" int commentRoutes



--parserComments =
--  string "comments"
--    |> map (\r -> ())
--routeComments =
--  route Comments parserComments


routeComments =
  route1 Comments "comments"



--parseComment =
--  string "comments/"
--    *> int
--routeComment =
--  route Comment parseComment


routeComment =
  route2 Comment "comments/" int


commentRoutes =
  [ routeComments, routeComment ]


routes =
  [ routePosts, routePost, routePostUser, routePostComments ]


paths =
  [ "/posts"
  , "/posts/11"
  , "/posts/11/users/1"
  , "/posts/11/comments"
  , "/posts/11/comments/22"
  ]


actions =
  [ Posts ()
  , Post (1)
  , PostUser ( 1, 2 )
  , PostComments ( 1, Comments () )
  , PostComments ( 1, Comment (1) )
  ]


parseResults =
  paths
    |> List.map (\path -> ( path, matchPath path routes ))


reverseResults =
  actions
    |> List.map (\action -> ( action, reverse action routes ))


parseResultsHtml =
  parseResults
    |> List.map (\tuple -> Html.div [] [ text (toString tuple) ])


reverserResultsHtml =
  reverseResults
    |> List.map (\tuple -> Html.div [] [ text (toString tuple) ])



--result =
--  matchPath path2 routes


main =
  Html.div
    []
    [ Html.div [] parseResultsHtml
    , Html.div [] reverserResultsHtml
    ]
