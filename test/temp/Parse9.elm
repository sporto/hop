module Parse9 (..) where

import Html exposing (text)
import Combine exposing (..)
import Combine.Num exposing (..)
import String
import Dict
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


-- TODO
-- Parse query
-- Reverse query
-------------------------------------
-- LIB


type alias Route action =
  { parser : Parser action
  , segments : List String
  }


type alias Query =
  Dict.Dict String String


newQuery : Query
newQuery =
  Dict.empty


parserWithBeginningAndEnd parser =
  parser <* Combine.end


route1 : (Query -> action) -> String -> Route action
route1 constructor segment1 =
  let
    constructor' =
      (\() -> constructor newQuery)

    parser =
      Combine.string segment1
        |> skip
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1 ]
    }


route2 : (input1 -> Query -> action) -> String -> Parser input1 -> Route action
route2 constructor segment1 parser1 =
  let
    constructor' input1 =
      constructor input1 newQuery

    parser =
      Combine.string segment1
        *> parser1
        |> parserWithBeginningAndEnd
        |> Combine.map constructor'
  in
    { parser = parser
    , segments = [ segment1 ]
    }


route4 : (input1 -> input2 -> Query -> action) -> String -> Parser input1 -> String -> Parser input2 -> Route action
route4 constructor segment1 parser1 segment2 parser2 =
  let
    constructor' ( a, b ) =
      constructor a b newQuery

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


toS =
  toString


nestedRoutes1 constructor segment1 parser1 children =
  let
    childrenParsers =
      List.map .parser children

    constructor' ( a, b ) =
      constructor a b newQuery

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


matchPath : (Query -> action) -> String -> List (Route action) -> action
matchPath notFoundAction path routeParsers =
  case routeParsers of
    [] ->
      notFoundAction newQuery

    [ routeParser ] ->
      case parse routeParser.parser path of
        ( Ok res, context ) ->
          res

        ( Err _, context ) ->
          notFoundAction newQuery

    routeParser :: rest ->
      case parse routeParser.parser path of
        ( Ok res, context ) ->
          res

        ( Err _, context ) ->
          matchPath notFoundAction path rest


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



------------------------------------------------------------
-- USER


type CommentRoutes
  = Comments Query
  | Comment Int Query


type UserRoute
  = Posts Query
  | Post Int Query
  | PostUser Int Int Query
  | PostToken Int String Query
  | PostComments Int CommentRoutes Query
  | Token String Query
  | NotFound Query


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
  [ routePosts, routePost, routePostUser, routePostToken, routeToken, routePostComments ]


pathsToMatch =
  [ "/posts"
  , "/posts?a=1"
  , "/posts/11"
  , "/posts/11?a=1"
  , "/posts/11/users/1"
  , "/posts/23/tokens/xyz"
  , "/posts/11/comments"
  , "/posts/11/comments?a=1"
  , "/posts/11/comments/22"
  , "/posts/22/monkeys"
  , "/tokens/abc"
  ]


actions =
  [ Posts newQuery
  , Post 1 newQuery
  , PostUser 1 2 newQuery
  , PostToken 7 "abc" newQuery
  , PostComments 1 (Comments newQuery) newQuery
  , PostComments 1 (Comment 1 newQuery) newQuery
  , Token "xyz" newQuery
  ]


reverse action =
  case action of
    Posts query ->
      routeToPath routePosts []

    Post id query ->
      routeToPath routePost [ toS id ]

    PostUser x y query ->
      routeToPath routePostUser [ toS x, toS y ]

    PostToken id token query ->
      routeToPath routePostToken [ toS id, token ]

    PostComments id subAction query ->
      let
        parent =
          routeToPath routePostComments [ toS id ]

        nested =
          case subAction of
            Comments query ->
              routeToPath routeComments []

            Comment commentId query ->
              routeToPath routeComment [ toS commentId ]
      in
        parent ++ nested

    Token token query ->
      routeToPath routeToken [ token ]

    NotFound query ->
      ""


parseResults =
  pathsToMatch
    |> List.map (\path -> ( path, matchPath NotFound path routes ))


parseResultsHtml =
  parseResults
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
    , Html.div [] reverserResultsHtml
    ]
