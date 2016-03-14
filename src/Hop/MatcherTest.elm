module Hop.MatcherTest (..) where

import Hop.Builder exposing (..)
import Hop.Matcher exposing (..)
import ElmTest exposing (..)


type TopLevelRoutes
  = Users
  | User Int
  | UserStatus Int
  | UsersToken String
  | UserToken Int String
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


usersTokenRoute =
  route2 UsersToken "/users/" str


userTokenRoute =
  route4 UserToken "/users/" int "/" str


userPostRoute =
  nested1 UserPosts "/users/" int postRoutes


topLevelRoutes =
  [ usersRoute, userRoute, userStatusRoute, usersTokenRoute, userPostRoute, userTokenRoute ]


matchPathTest : Test
matchPathTest =
  let
    inputs =
      [ ( "Matches users", "/users", Users )
      , ( "Matches one user", "/users/1", User 1 )
      , ( "Matches user status", "/users/2/status", UserStatus 2 )
      , ( "Matches users token", "/users/abc", UsersToken "abc" )
      , ( "Matches one user token", "/users/3/abc", UserToken 3 "abc" )
      , ( "Matches user posts", "/users/4/posts", UserPosts 4 (Posts) )
      , ( "Matches one user post", "/users/4/posts/2", UserPosts 4 (Post 2) )
      , ( "Matches not found", "/posts", NotFound )
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
