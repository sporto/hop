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
    | Other String
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


catchAllRoute =
    match2 Other "/" (regex ".+")


matchers =
    [ rootRoute
    , usersRoute
    , userRoute
    , userStatusRoute
    , usersTokenRoute
    , userPostRoute
    , userTokenRoute
    ]

matchersWithCatchAll =
    List.append matchers [catchAllRoute]


config =
    { hash = True
    , basePath = ""
    , matchers = matchers
    , notFound = NotFound
    }

configWitCatchAll = 
    { config | matchers = matchersWithCatchAll  }


configWithPath =
    { config | hash = False }


configWithBasePath =
    { configWithPath | basePath = "app" }



-- TODO add root "/"


matchUrlTest : Test
matchUrlTest =
    let
        inputs =
            [ ( "hash: Matches users"
              , config
              , "http://example.com"
              , ( Users, { path = [], query = Dict.empty } )
              )
            , ( "path: Matches users"
              , configWithPath
              , "http://example.com"
              , ( Users, { path = [], query = Dict.empty } )
              )
            , ( "basePath: Matches users"
              , configWithBasePath
              , "http://example.com"
              , ( Users, { path = [], query = Dict.empty } )
              )
              -- users
            , ( "hash: Matches users"
              , config
              , "http://example.com/#/users"
              , ( Users, { path = [ "users" ], query = Dict.empty } )
              )
            , ( "path: Matches users"
              , configWithPath
              , "http://example.com/users"
              , ( Users, { path = [ "users" ], query = Dict.empty } )
              )
            , ( "basePath: Matches users"
              , configWithBasePath
              , "http://example.com/app/users"
              , ( Users, { path = [ "users" ], query = Dict.empty } )
              )
              -- one user
            , ( "hash: Matches one user"
              , config
              , "http://example.com/#/users/1"
              , ( User 1, { path = [ "users", "1" ], query = Dict.empty } )
              )
            , ( "path: Matches one user"
              , configWithPath
              , "http://example.com/users/1"
              , ( User 1, { path = [ "users", "1" ], query = Dict.empty } )
              )
            , ( "basePath: Matches one user"
              , configWithBasePath
              , "http://example.com/app/users/1"
              , ( User 1, { path = [ "users", "1" ], query = Dict.empty } )
              )
              -- user status
            , ( "hash: Matches user status"
              , config
              , "http://example.com/#/users/2/status"
              , ( UserStatus 2, { path = [ "users", "2", "status" ], query = Dict.empty } )
              )
            , ( "path: Matches user status"
              , configWithPath
              , "http://example.com/users/2/status"
              , ( UserStatus 2, { path = [ "users", "2", "status" ], query = Dict.empty } )
              )
            , ( "basePath: Matches user status"
              , configWithBasePath
              , "http://example.com/app/users/2/status"
              , ( UserStatus 2, { path = [ "users", "2", "status" ], query = Dict.empty } )
              )
              -- users token
            , ( "hash: Matches users token"
              , config
              , "http://example.com/#/users/abc"
              , ( UsersToken "abc", { path = [ "users", "abc" ], query = Dict.empty } )
              )
            , ( "path: Matches users token"
              , configWithPath
              , "http://example.com/users/abc"
              , ( UsersToken "abc", { path = [ "users", "abc" ], query = Dict.empty } )
              )
              -- one user token
            , ( "hash: Matches one user token"
              , config
              , "http://example.com/#/users/3/abc"
              , ( UserToken 3 "abc", { path = [ "users", "3", "abc" ], query = Dict.empty } )
              )
            , ( "path: Matches one user token"
              , configWithPath
              , "http://example.com/users/3/abc"
              , ( UserToken 3 "abc", { path = [ "users", "3", "abc" ], query = Dict.empty } )
              )
              -- user posts
            , ( "hash: Matches user posts"
              , config
              , "http://example.com/#/users/4/posts"
              , ( UserPosts 4 (Posts), { path = [ "users", "4", "posts" ], query = Dict.empty } )
              )
            , ( "hash: Matches one user post"
              , config
              , "http://example.com/#/users/4/posts/2"
              , ( UserPosts 4 (Post 2), { path = [ "users", "4", "posts", "2" ], query = Dict.empty } )
              )
            , ( "hash: catch all"
              , configWitCatchAll
              , "http://example.com/#/monkeys/1/punch"
              , ( Other "monkeys/1/punch", { path = [ "monkeys", "1", "punch" ], query = Dict.empty } )
              )
              -- not found
            , ( "hash: Matches not found"
              , config
              , "http://example.com/#/posts"
              , ( NotFound, { path = [ "posts" ], query = Dict.empty } )
              )
            , ( "path: Matches not found"
              , configWithPath
              , "http://example.com/app/users"
              , ( NotFound, { path = [ "app", "users" ], query = Dict.empty } )
              )
            ]

        run ( testCase, cfg, input, expected ) =
            let
                actual =
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
