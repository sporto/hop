module Hop.MatcherTest (..) where

import Hop.Matcher exposing (..)
import Hop.Builder exposing (..)


--import Hop.Types exposing (Query)

import ElmTest exposing (..)


--type PostCommentRoutes
--  = Comments Query
--  | Comment Int Query


type PostCommentRoutes
  = Comments () Query



--type RootRoutes
--  = NotFound
--  | Posts Query
--  | PostsSub PostCommentRoutes
--  | Post Int Query
--  | PostDetails Int Query
--  | PostComments Int Query PostCommentRoutes


type RootRoutes
  = NotFound () Query
  | Posts () Query
  | PostsSub () Query PostCommentRoutes



--commentRoutes =
--  [ route1 Comments (path1 "/comments") []
--  , route1 Comment (path2 "/comments/" int) []
--  ]
--routes =
--  [ route1 Post (path2 "/posts/" int) []
--  , route1 PostDetails (path3 "/posts/" int "/details") []
--  , route1 PostComments (path2 "/posts/" int) commentRoutes
--  ]
--commentRoutes : Routes PostCommentRoutes


commentRoutes =
  [ Route "/comments" Comments
  ]



--routes : List (Route (Query -> Routes))
--routes : Routes RootRoutes


routes =
  [ Route "/posts" Posts
  , ParentRoute "/posts/" PostsSub commentRoutes
  ]



--, route "/posts" PostsSub commentRoutes


matchTest : Test
matchTest =
  let
    inputs =
      [ ( "Matches posts", "/posts", "Posts--" )
      ]

    run ( testCase, input, expected ) =
      let
        actual =
          match input

        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite "match" (List.map run inputs)


allTest : List Test
allTest =
  [ matchTest ]


all : Test
all =
  suite "ResolverTest" allTest
