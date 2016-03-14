module Hop.BuilderTest (..) where

import Hop.Builder exposing (..)
import ElmTest exposing (..)


type TopLevelRoutes
  = Users
  | User Int
  | UserStatus Int
  | UserToken String
  | UserPosts Int (PostNestedRoutes)


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
  nestedRoutes1 UserPosts "/users/" int postRoutes


topLevelRoutes =
  [ usersRoute, userRoute, userStatusRoute, userTokenRoute ]


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
