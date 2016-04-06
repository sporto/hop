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


rootRoute =
  match1 Users ""


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
  [ rootRoute, usersRoute, userRoute, userStatusRoute, usersTokenRoute, userPostRoute, userTokenRoute ]


config =
  { hash = True
  , basePath = ""
  , matchers = topLevelRoutes
  , notFound = NotFound
  }


configWithPath =
  { config | hash = False }



-- TODO add root "/"


matchPathTest : Test
matchPathTest =
  let
    inputs =
      [ ( "hash: Matches users"
        , config
        , ""
        , Users
        )
      , ( "path: Matches users"
        , configWithPath
        , ""
        , Users
        )
        -- users
      , ( "hash: Matches users"
        , config
        , "/users"
        , Users
        )
      , ( "path: Matches users"
        , configWithPath
        , "/users"
        , Users
        )
        -- one user
      , ( "hash: Matches one user"
        , config
        , "/users/1"
        , User 1
        )
      , ( "path: Matches one user"
        , configWithPath
        , "/users/1"
        , User 1
        )
        -- user status
      , ( "hash: Matches user status"
        , config
        , "/users/2/status"
        , UserStatus 2
        )
      , ( "path: Matches user status"
        , configWithPath
        , "/users/2/status"
        , UserStatus 2
        )
        -- users token
      , ( "hash: Matches users token"
        , config
        , "/users/abc"
        , UsersToken "abc"
        )
      , ( "path: Matches users token"
        , configWithPath
        , "/users/abc"
        , UsersToken "abc"
        )
        -- one user token
      , ( "hash: Matches one user token"
        , config
        , "/users/3/abc"
        , UserToken 3 "abc"
        )
      , ( "path: Matches one user token"
        , configWithPath
        , "/users/3/abc"
        , UserToken 3 "abc"
        )
        -- user posts
      , ( "hash: Matches user posts"
        , config
        , "/users/4/posts"
        , UserPosts 4 (Posts)
        )
      , ( "hash: Matches one user post"
        , config
        , "/users/4/posts/2"
        , UserPosts 4 (Post 2)
        )
        -- not found
      , ( "hash: Matches not found"
        , config
        , "/posts"
        , NotFound
        )
      , ( "path: Matches not found"
        , configWithPath
        , "/app/users"
        , NotFound
        )
      ]

    run ( testCase, cfg, input, expected ) =
      let
        actual =
          matchPath cfg input

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
      [ ( "hash: Matches root"
        , config
        , { path = [], query = newQuery }
        , Users
        )
      , ( "path: Matches root"
        , configWithPath
        , { path = [], query = newQuery }
        , Users
        )
        -- users
      , ( "hash: Matches users"
        , config
        , { path = [ "users" ], query = newQuery }
        , Users
        )
      , ( "path: Matches users"
        , configWithPath
        , { path = [ "users" ], query = newQuery }
        , Users
        )
        -- users with query
      , ( "hash: Matches users with query"
        , config
        , { path = [ "users" ], query = Dict.singleton "a" "1" }
        , Users
        )
      , ( "path: Matches users with query"
        , configWithPath
        , { path = [ "users" ], query = Dict.singleton "a" "1" }
        , Users
        )
        -- one user
      , ( "hash: Matches one user"
        , config
        , { path = [ "users", "1" ], query = newQuery }
        , User 1
        )
        -- one user with query
      , ( "hash: Matches one user with query"
        , config
        , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
        , User 1
        )
        -- user status
      , ( "hash: Matches user status"
        , config
        , { path = [ "users", "2", "status" ], query = newQuery }
        , UserStatus 2
        )
        -- users token
      , ( "hash: Matches users token"
        , config
        , { path = [ "users", "abc" ], query = newQuery }
        , UsersToken "abc"
        )
        -- one user token
      , ( "hash: Matches one user token"
        , config
        , { path = [ "users", "3", "abc" ], query = newQuery }
        , UserToken 3 "abc"
        )
        -- user posts
      , ( "hash: Matches user posts"
        , config
        , { path = [ "users", "4", "posts" ], query = newQuery }
        , UserPosts 4 (Posts)
        )
        -- one user post
      , ( "hash: Matches one user post"
        , config
        , { path = [ "users", "4", "posts", "2" ], query = newQuery }
        , UserPosts 4 (Post 2)
        )
        -- one user post with query
      , ( "hash: Matches one user post with query"
        , config
        , { path = [ "users", "4", "posts", "2" ], query = Dict.singleton "a" "1" }
        , UserPosts 4 (Post 2)
        )
      , ( "path: Matches one user post with query"
        , configWithPath
        , { path = [ "users", "4", "posts", "2" ], query = Dict.singleton "a" "1" }
        , UserPosts 4 (Post 2)
        )
        -- not found
      , ( "hash: Matches not found"
        , config
        , { path = [ "posts" ], query = newQuery }
        , NotFound
        )
      ]

    run ( testCase, cfg, input, expected ) =
      let
        actual =
          matchLocation cfg input

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
