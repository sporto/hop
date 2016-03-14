module Hop.MatcherTest (..) where

import Hop.Builder exposing (..)
import Hop.Matcher exposing (..)
import ElmTest exposing (..)


type TopLevelRoutes
  = Users
  | User Int
  | UserStatus Int
  | UserToken String
  | UserPosts Int (PostNestedRoutes)
  | NotFound


type PostNestedRoutes
  = Posts
  | Post Int


postsRoute =
  route1 Posts "/posts"


postRoute =
  route2 Post "/posts/" int


postRoutes =
  [ postsRoute, postRoute ]


usersRoute =
  route1 Users "/users"


userRoute =
  route2 User "/users/" int


userStatusRoute =
  route3 UserStatus "/users/" int "/status"


userTokenRoute =
  route2 UserToken "/users/" str


userPostRoute =
  nested1 UserPosts "/users/" int postRoutes


topLevelRoutes =
  [ usersRoute, userRoute, userStatusRoute, userTokenRoute ]


matchPathTest : Test
matchPathTest =
  let
    inputs =
      [ ( "Matches users", "/users", Users )
      , ( "Matches users", "/users/1", User 1 )
      ]

    run ( testCase, input, expected ) =
      let
        actual =
          matchPath topLevelRoutes NotFound input

        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite "matchPath" (List.map run inputs)


allTest : List Test
allTest =
  [ matchPathTest ]


all : Test
all =
  suite "MatcherTest" allTest
