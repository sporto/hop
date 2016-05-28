module HopTest exposing (..)

import Dict
import ElmTest exposing (..)

import Hop exposing (..)
import Hop.Location as Location
import Hop.Types exposing (..)
import Hop.Matchers exposing (..)


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


matchUrlTest : Test
matchUrlTest =
  let
    inputs =
      [ ( "hash: Matches users"
        , config
        , "http://example.com"
        , Users
        )
      , ( "path: Matches users"
        , configWithPath
        , "http://example.com"
        , Users
        )
        -- users
      , ( "hash: Matches users"
        , config
        , "http://example.com#/users"
        , Users
        )
      , ( "path: Matches users"
        , configWithPath
        , "http://example.com/users"
        , Users
        )
        -- one user
      , ( "hash: Matches one user"
        , config
        , "http://example.com#/users/1"
        , User 1
        )
      , ( "path: Matches one user"
        , configWithPath
        , "http://example.com/users/1"
        , User 1
        )
        -- user status
      , ( "hash: Matches user status"
        , config
        , "http://example.com#/users/2/status"
        , UserStatus 2
        )
      , ( "path: Matches user status"
        , configWithPath
        , "http://example.com/users/2/status"
        , UserStatus 2
        )
        -- users token
      , ( "hash: Matches users token"
        , config
        , "http://example.com#/users/abc"
        , UsersToken "abc"
        )
      , ( "path: Matches users token"
        , configWithPath
        , "http://example.com/users/abc"
        , UsersToken "abc"
        )
        -- one user token
      , ( "hash: Matches one user token"
        , config
        , "http://example.com#/users/3/abc"
        , UserToken 3 "abc"
        )
      , ( "path: Matches one user token"
        , configWithPath
        , "http://example.com/users/3/abc"
        , UserToken 3 "abc"
        )
        -- user posts
      , ( "hash: Matches user posts"
        , config
        , "http://example.com#/users/4/posts"
        , UserPosts 4 (Posts)
        )
      , ( "hash: Matches one user post"
        , config
        , "http://example.com/users/4/posts/2"
        , UserPosts 4 (Post 2)
        )
        -- not found
      , ( "hash: Matches not found"
        , config
        , "http://example.com#/posts"
        , NotFound
        )
      , ( "path: Matches not found"
        , configWithPath
        , "http://example.com/app/users"
        , NotFound
        )
      ]

    run ( testCase, cfg, input, expected ) =
      let
        (actual, location) =
          matchUrl cfg input

        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite "matchUrl" (List.map run inputs)


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
    suite "matcherToPath" (List.map run inputs)


allTest : List Test
allTest =
  [ matchUrlTest, matcherToPathTest ]


all : Test
all =
  suite "MatcherTest" allTest

