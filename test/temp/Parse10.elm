module Parse10 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import String
import Dict
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))
import Hop.Url


-- LIB


type alias Query =
  Dict.Dict String String


type alias Route action =
  { parser : Parser action
  , segments : List String
  }


newQuery : Query
newQuery =
  Dict.empty


parserWithBeginningAndEnd parser =
  parser <* Combine.end


route1 : action -> String -> Route action
route1 constructor segment1 =
  let
    parser =
      Combine.string segment1
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
      Combine.string segment1
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
      Combine.string segment1
        *> parser1
        `andThen` (\r -> map (\x -> ( r, x )) (Combine.string segment2 *> parser2))
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1, segment2 ]
    }



-- PostComments ( Int, Comment (1) )
-- PostComments 1 (Comment 1)
--nestedRoutes1 : (( inputs, subInputs ) -> action) -> String -> Parser inputs -> List (Route subInputs) -> Route action


toS =
  toString


nestedRoutes1 constructor segment1 parser1 children =
  let
    childrenParsers =
      List.map .parser children

    constructor' ( a, b ) =
      constructor a b

    parser =
      Combine.string segment1
        *> parser1
        `andThen` (\r -> map (\x -> ( r, x )) (choice childrenParsers))
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1 ]
    }


matchPath notFoundAction path routeParsers =
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
          matchPath notFoundAction path rest


matchPathWithQuery routingAction notFoundAction fullPath routeParsers =
  let
    url =
      Hop.Url.parse fullPath

    path =
      "/" ++ (String.join "/" url.path)
  in
    routingAction ( matchPath notFoundAction path routeParsers, url.query )



-- loop through every route
-- get the constructor
-- pattern match on the given action
--routeToPath route inputs =
--  let
--    makeSegment segment input =
--      segment ++ (toString input)
--  in
--    List.map2 makeSegment route.segments inputs
--      |> String.join ""


routeToPath : Route a -> List String -> String
routeToPath route inputs =
  let
    makeSegment segment input =
      segment ++ input
  in
    List.map2 makeSegment route.segments inputs
      |> String.join ""


str =
  Combine.regex "[^/]+"



--reverseNested route inputs1 nestedRoute inputs2 =
--  let
--    makeSegment segment input =
--      segment ++ (toString input)
--    path =
--      List.map2 makeSegment route.segments inputs1
--        |> String.join ""
--    nestedPath =
--      List.map2 makeSegment nestedRoute.segments inputs2
--        |> String.join ""
--  in
--    path ++ "/" ++ nestedPath
------------------------------------------------------------
-- USER


type CommentRoutes
  = Comments
  | Comment Int


type UserRoute
  = Posts
  | Post Int
  | PostUser Int Int
  | PostToken Int String
  | PostComments Int CommentRoutes
  | Token String
  | NotFound


type Action
  = ShowView ( UserRoute, Query )
  | NoOp


routePostUser =
  route4 PostUser "/posts/" int "/users/" int


routePosts =
  route1 Posts "/posts"


routePost =
  route2 Post "/posts/" int


routePostToken =
  route4 PostToken "/posts/" int "/tokens/" str


routePostComments =
  nestedRoutes1 PostComments "/posts/" int commentRoutes


routeToken =
  route2 Token "/tokens/" str


routeComments =
  route1 Comments "/comments"


routeComment =
  route2 Comment "/comments/" int


commentRoutes =
  [ routeComments, routeComment ]


routes =
  [ routePosts, routePost, routePostUser, routePostToken, routePostComments, routeToken ]


paths =
  [ "/posts"
  , "/posts?a=1"
  , "/posts/11"
  , "/posts/11/users/1"
  , "/posts/23/tokens/xyz"
  , "/posts/11/comments"
  , "/posts/11/comments/22"
  , "/posts/11/comments/22?a=1"
  , "/posts/22/monkeys"
  , "/tokens/abc"
  ]


actions =
  [ Posts
  , Post 1
  , PostUser 1 2
  , PostToken 7 "abc"
  , PostComments 1 Comments
  , PostComments 1 (Comment 1)
  , Token "xyz"
  ]


reverse action =
  case action of
    Posts ->
      routeToPath routePosts []

    Post id ->
      routeToPath routePost [ toS id ]

    PostUser x y ->
      routeToPath routePostUser [ toS x, toS y ]

    PostToken id token ->
      routeToPath routePostToken [ toS id, token ]

    PostComments id subAction ->
      let
        parent =
          routeToPath routePostComments [ toS id ]

        nested =
          case subAction of
            Comments ->
              routeToPath routeComments []

            Comment commentId ->
              routeToPath routeComment [ toS commentId ]
      in
        parent ++ nested

    Token token ->
      routeToPath routeToken [ token ]

    NotFound ->
      ""



--"/post/" ++ (toString x)


parseResults =
  let
    removeQuery path =
      path
        |> String.split "?"
        |> List.head
        |> Maybe.withDefault ""
  in
    paths
      |> List.map (\path -> ( path, matchPath NotFound (removeQuery path) routes ))


parseResultsHtml =
  parseResults
    |> List.map (\tuple -> Html.div [] [ text (toString tuple) ])


parseResultsWithQuery =
  paths
    |> List.map (\path -> ( path, matchPathWithQuery ShowView NotFound path routes ))


parseResultsWithQueryHtml =
  parseResultsWithQuery
    |> List.map (\tuple -> Html.div [] [ text (toString tuple) ])


reverseResults =
  actions
    |> List.map (\action -> ( action, reverse action ))


reverserResultsHtml =
  reverseResults
    |> List.map (\tuple -> Html.div [] [ text (toString tuple) ])


main =
  Html.div
    []
    [ Html.div [] parseResultsHtml
    , Html.div [] [ Html.text "----------------" ]
    , Html.div [] parseResultsWithQueryHtml
    , Html.div [] [ Html.text "----------------" ]
    , Html.div [] reverserResultsHtml
    ]
