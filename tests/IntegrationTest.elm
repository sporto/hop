module IntegrationTest exposing (..)

import UrlParser exposing ((</>), oneOf, int, s)
import Expect
import String
import Test exposing (..)
import Hop.TestHelper exposing (configWithHash, configWithPath, configPathAndBasePath)
import Hop


type alias UserId =
    Int


type UserRoute
    = UsersRoute
    | UserRoute UserId
    | UserEditRoute UserId


type MainRoute
    = HomeRoute
    | AboutRoute
    | UsersRoutes UserRoute
    | NotFoundRoute


usersMatchers =
    [ UrlParser.format UserEditRoute (int </> s "edit")
    , UrlParser.format UserRoute (int)
    , UrlParser.format UsersRoute (s "")
    ]


mainMatchers =
    [ UrlParser.format HomeRoute (s "")
    , UrlParser.format AboutRoute (s "about")
    , UrlParser.format UsersRoutes (s "users" </> (oneOf usersMatchers))
    ]


routes =
    oneOf mainMatchers


parseWithUrlParser currentConfig location =
    let
        -- _ =
        --     Debug.log "parseResult" parseResult
        -- _ =
        --     Debug.log "path" path
        address =
            location.href
                |> Hop.ingest currentConfig

        path =
            Hop.pathFromAddress address
                ++ "/"
                |> String.dropLeft 1

        parseResult =
            UrlParser.parse identity routes path

        route =
            Result.withDefault NotFoundRoute parseResult
    in
        ( route, address )


urlParserIntegrationTest : Test
urlParserIntegrationTest =
    let
        inputs =
            [ ( "Home page"
              , configWithPath
              , "http://example.com"
              , HomeRoute
              , "/"
              )
            , ( "Base: Home page"
              , configPathAndBasePath
              , "http://example.com/app/v1"
              , HomeRoute
              , "/app/v1"
              )
            , ( "Hash: Home page with /#"
              , configWithHash
              , "http://example.com/#"
              , HomeRoute
              , "#/"
              )
            , ( "Hash: Home page with /#/"
              , configWithHash
              , "http://example.com/#/"
              , HomeRoute
              , "#/"
              )
            , ( "Hash: Home page without hash"
              , configWithHash
              , "http://example.com"
              , HomeRoute
              , "#/"
              )
            , ( "Hash: Home page"
              , configWithHash
              , "http://example.com/index.html"
              , HomeRoute
              , "#/"
              )
              -- about
            , ( "AboutRoute"
              , configWithPath
              , "http://example.com/about"
              , AboutRoute
              , "/about"
              )
            , ( "Base: AboutRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/about"
              , AboutRoute
              , "/app/v1/about"
              )
            , ( "Hash: AboutRoute"
              , configWithHash
              , "http://example.com/#/about"
              , AboutRoute
              , "#/about"
              )
            , ( "Hash: AboutRoute with slash"
              , configWithHash
              , "http://example.com/app#/about"
              , AboutRoute
              , "#/about"
              )
              -- users
            , ( "UsersRoute"
              , configWithPath
              , "http://example.com/users"
              , UsersRoutes UsersRoute
              , "/users"
              )
            , ( "Base: UsersRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/users"
              , UsersRoutes UsersRoute
              , "/app/v1/users"
              )
            , ( "Hash: UsersRoute"
              , configWithHash
              , "http://example.com/#/users"
              , UsersRoutes UsersRoute
              , "#/users"
              )
              -- users with query
            , ( "UsersRoute"
              , configWithPath
              , "http://example.com/users?k=1"
              , UsersRoutes UsersRoute
              , "/users?k=1"
              )
            , ( "Base: UsersRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/users?k=1"
              , UsersRoutes UsersRoute
              , "/app/v1/users?k=1"
              )
            , ( "Hash: UsersRoute"
              , configWithHash
              , "http://example.com/#/users?k=1"
              , UsersRoutes UsersRoute
              , "#/users?k=1"
              )
              -- user
            , ( "UserRoute"
              , configWithPath
              , "http://example.com/users/2"
              , UsersRoutes (UserRoute 2)
              , "/users/2"
              )
            , ( "Base: UserRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/users/2"
              , UsersRoutes (UserRoute 2)
              , "/app/v1/users/2"
              )
            , ( "Hash: UserRoute"
              , configWithHash
              , "http://example.com/#/users/2"
              , UsersRoutes (UserRoute 2)
              , "#/users/2"
              )
              -- user edit
            , ( "UserRoute"
              , configWithPath
              , "http://example.com/users/2/edit"
              , UsersRoutes (UserEditRoute 2)
              , "/users/2/edit"
              )
            , ( "Base: UserRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/users/2/edit"
              , UsersRoutes (UserEditRoute 2)
              , "/app/v1/users/2/edit"
              )
            , ( "Hash: UserRoute"
              , configWithHash
              , "http://example.com/#/users/2/edit"
              , UsersRoutes (UserEditRoute 2)
              , "#/users/2/edit"
              )
            ]

        run ( testCase, currentConfig, href, expected, expectedRoundTrip ) =
            [ test testCase
                <| \() ->
                    let
                        location =
                            { href = href }

                        ( actual, _ ) =
                            parseWithUrlParser currentConfig location
                    in
                        Expect.equal expected actual
            , test (testCase ++  " - output")
                <| \() ->
                    let
                        location =
                            { href = href }

                        ( _, address ) =
                            parseWithUrlParser currentConfig location

                        actual =
                            Hop.output currentConfig address
                    in
                        Expect.equal expectedRoundTrip actual
            ]
    in
        describe "UrlParser integration" (List.concatMap run inputs)


all : Test
all =
    describe "Integration"
        [ urlParserIntegrationTest
        ]