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


route1 : (() -> action) -> String -> Parser action
route1 constructor segment =
  let
    parser =
      string segment
        |> skip
  in
    route constructor parser


route2 : (inputs -> action) -> String -> Parser inputs -> Parser action
route2 constructor segment parser1 =
  let
    parser =
      string segment
        *> parser1
  in
    route constructor parser


route4 : (( input1, input2 ) -> action) -> String -> Parser input1 -> String -> Parser input2 -> Parser action
route4 constructor segment1 parser1 segment2 parser2 =
  let
    parser =
      string segment1
        *> parser1
        `andThen` (\r -> map (\x -> ( r, x )) (string segment2 *> parser2))
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


routePostUser =
  route4 PostUser "posts/" int "/users/" int


routePosts =
  route1 Posts "posts"


routePost =
  route2 Post "posts/" int


routePostComments =
  nestedRoutes1 PostComments "posts/" int commentRoutes


routeComments =
  route1 Comments "comments"


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


main =
  Html.div
    []
    [ Html.div [] parseResultsHtml
    , Html.div [] reverserResultsHtml
    ]
