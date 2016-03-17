module Parse7 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- TODO
-- Reverse routing
-- Query
-- Maybe not tuples for actions
--
-- LIB


type alias Route action =
  { parser : Parser action
  , segments : List String
  }



--route : (inputs -> res) -> Parser inputs -> List String -> Route res
--route constructor parser segments =
--  let
--    parserWithBeginningAndEnd =
--      (Combine.string "/" *> parser <* Combine.end)
--  in
--    { parser = Combine.map constructor parserWithBeginningAndEnd
--    , segments = segments
--    }


parserWithBeginningAndEnd parser =
  (Combine.string "/" *> parser <* Combine.end)


route1 : action -> String -> Route action
route1 constructor segment1 =
  let
    parser =
      string segment1
        |> skip
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
      string segment1
        *> parser1
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1 ]
    }


route4 : (input1 -> input2 -> action) -> String -> Parser input1 -> String -> Parser input2 -> Route action
route4 constructor segment1 parser1 segment2 parser2 =
  let
    constructor' ( a, b ) =
      constructor a b

    parser =
      string segment1
        *> parser1
        `andThen` (\r -> map (\x -> ( r, x )) (string segment2 *> parser2))
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1, segment2 ]
    }



-- PostComments ( Int, Comment (1) )
-- PostComments 1 (Comment 1)
--nestedRoutes1 : (( inputs, subInputs ) -> action) -> String -> Parser inputs -> List (Route subInputs) -> Route action


nestedRoutes1 constructor segment1 parser1 children =
  let
    childrenParsers =
      List.map .parser children

    constructor' ( a, b ) =
      constructor a b

    parser =
      string segment1
        *> parser1
        `andThen` (\r -> map (\x -> ( r, x )) (choice childrenParsers))
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1 ]
    }


matchPath path routeParsers =
  case routeParsers of
    [] ->
      NotFound

    [ routeParser ] ->
      case parse routeParser.parser path of
        ( Ok res, context ) ->
          res

        ( Err _, context ) ->
          NotFound

    routeParser :: rest ->
      case parse routeParser.parser path of
        ( Ok res, context ) ->
          res

        ( Err _, context ) ->
          matchPath path rest



-- USER


type CommentRoutes
  = Comments
  | Comment Int


type UserRoute
  = Posts
  | Post Int
  | PostUser Int Int
  | PostComments Int CommentRoutes
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
  , "/posts/22/monkeys"
  ]


parseResults =
  paths
    |> List.map (\path -> ( path, matchPath path routes ))


parseResultsHtml =
  parseResults
    |> List.map (\tuple -> Html.div [] [ text (toString tuple) ])


main =
  Html.div
    []
    [ Html.div [] parseResultsHtml
    ]
