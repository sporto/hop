module Hop.MatcherTest (..) where

import Dict
import Hop.Builder exposing (..)
import Hop.Matcher exposing (..)
import Hop.Url exposing (Query, newQuery)
import ElmTest exposing (..)


type Action
  = Show ( TopLevelRoutes, Query )


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


matchLocationTest : Test
matchLocationTest =
  let
    inputs =
      [ ( "Matches users"
        , "/users"
        , Show ( Users, newQuery )
        )
      , ( "Matches users with query"
        , "/users?a=1"
        , Show ( Users, Dict.singleton "a" "1" )
        )
      , ( "Matches one user"
        , "/users/1"
        , Show ( User 1, newQuery )
        )
      , ( "Matches one user with query"
        , "/users/1?a=1"
        , Show ( User 1, Dict.singleton "a" "1" )
        )
      , ( "Matches user status"
        , "/users/2/status"
        , Show ( UserStatus 2, newQuery )
        )
      , ( "Matches users token"
        , "/users/abc"
        , Show ( UsersToken "abc", newQuery )
        )
      , ( "Matches one user token"
        , "/users/3/abc"
        , Show ( UserToken 3 "abc", newQuery )
        )
      , ( "Matches user posts"
        , "/users/4/posts"
        , Show ( UserPosts 4 (Posts), newQuery )
        )
      , ( "Matches one user post"
        , "/users/4/posts/2"
        , Show ( UserPosts 4 (Post 2), newQuery )
        )
      , ( "Matches one user post with query"
        , "/users/4/posts/2?a=1"
        , Show ( UserPosts 4 (Post 2), Dict.singleton "a" "1" )
        )
      , ( "Matches not found"
        , "/posts"
        , Show ( NotFound, newQuery )
        )
      ]

    run ( testCase, input, expected ) =
      let
        actual =
          matchLocation topLevelRoutes Show NotFound input

        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite "matchLocation" (List.map run inputs)


allTest : List Test
allTest =
  [ matchPathTest, matchLocationTest ]


all : Test
all =
  suite "MatcherTest" allTest
