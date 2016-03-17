module Hop.MatchersTest (..) where

import Dict
import Hop
import Hop.Matchers exposing (..)
import Hop.Location as Location
import Hop.Types exposing (..)
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
  match1 Posts "/posts"


postRoute =
  match2 Post "/posts/" int


postRoutes =
  [ postsRoute, postRoute ]


usersRoute =
  match1 Users "/users"


userRoute =
  match2 User "/users/" int


userStatusRoute =
  match3 UserStatus "/users/" int "/status"


usersTokenRoute =
  match2 UsersToken "/users/" str


userTokenRoute =
  match4 UserToken "/users/" int "/" str


userPostRoute =
  nested2 UserPosts "/users/" int postRoutes


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
        , ( Users, { path = [ "users" ], query = newQuery } )
        )
      , ( "Matches users with query"
        , "/users?a=1"
        , ( Users, { path = [ "users" ], query = Dict.singleton "a" "1" } )
        )
      , ( "Matches one user"
        , "/users/1"
        , ( User 1, { path = [ "users", "1" ], query = newQuery } )
        )
      , ( "Matches one user with query"
        , "/users/1?a=1"
        , ( User 1, { path = [ "users", "1" ], query = Dict.singleton "a" "1" } )
        )
      , ( "Matches user status"
        , "/users/2/status"
        , ( UserStatus 2, { path = [ "users", "2", "status" ], query = newQuery } )
        )
      , ( "Matches users token"
        , "/users/abc"
        , ( UsersToken "abc", { path = [ "users", "abc" ], query = newQuery } )
        )
      , ( "Matches one user token"
        , "/users/3/abc"
        , ( UserToken 3 "abc", { path = [ "users", "3", "abc" ], query = newQuery } )
        )
      , ( "Matches user posts"
        , "/users/4/posts"
        , ( UserPosts 4 (Posts), { path = [ "users", "4", "posts" ], query = newQuery } )
        )
      , ( "Matches one user post"
        , "/users/4/posts/2"
        , ( UserPosts 4 (Post 2), { path = [ "users", "4", "posts", "2" ], query = newQuery } )
        )
      , ( "Matches one user post with query"
        , "/users/4/posts/2?a=1"
        , ( UserPosts 4 (Post 2), { path = [ "users", "4", "posts", "2" ], query = Dict.singleton "a" "1" } )
        )
      , ( "Matches not found"
        , "/posts"
        , ( NotFound, { path = [ "posts" ], query = newQuery } )
        )
      ]

    run ( testCase, input, expected ) =
      let
        actual =
          matchLocation topLevelRoutes NotFound input

        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite "matchLocation" (List.map run inputs)


matcherToPathTest : Test
matcherToPathTest =
  let
    inputs =
      [ ( "Users", usersRoute, [], "/users" )
      , ( "One user", userRoute, [ "2" ], "/users/2" )
      , ( "Too many inputs", userRoute, [ "2", "3" ], "/users/2" )
      , ( "User status", userStatusRoute, [ "3" ], "/users/3/status" )
      ]

    run ( testCase, route, params, expected ) =
      let
        actual =
          matcherToPath route params

        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite "matchPath" (List.map run inputs)


allTest : List Test
allTest =
  [ matchPathTest, matchLocationTest, matcherToPathTest ]


all : Test
all =
  suite "MatcherTest" allTest
