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
              , "http://example.com/"
              , HomeRoute
              )
            , ( "Home page without trailing slash"
              , configWithPath
              , "http://example.com"
              , HomeRoute
              )
            , ( "Base: Home page"
              , configPathAndBasePath
              , "http://example.com/app/v1"
              , HomeRoute
              )
            , ( "Hash: Home page"
              , configWithHash
              , "http://example.com/#"
              , HomeRoute
              )
              -- about
            , ( "AboutRoute"
              , configWithPath
              , "http://example.com/about"
              , AboutRoute
              )
            , ( "Base: AboutRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/about"
              , AboutRoute
              )
            , ( "Hash: AboutRoute"
              , configWithHash
              , "http://example.com/#about"
              , AboutRoute
              )
            , ( "Hash: AboutRoute with slash"
              , configWithHash
              , "http://example.com/app#/about"
              , AboutRoute
              )
              -- users
            , ( "UsersRoute"
              , configWithPath
              , "http://example.com/users"
              , UsersRoutes UsersRoute
              )
            , ( "Base: UsersRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/users"
              , UsersRoutes UsersRoute
              )
            , ( "Hash: UsersRoute"
              , configWithHash
              , "http://example.com/#users"
              , UsersRoutes UsersRoute
              )
              -- user
            , ( "UserRoute"
              , configWithPath
              , "http://example.com/users/2"
              , UsersRoutes (UserRoute 2)
              )
            , ( "Base: UserRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/users/2"
              , UsersRoutes (UserRoute 2)
              )
            , ( "Hash: UserRoute"
              , configWithHash
              , "http://example.com/#users/2"
              , UsersRoutes (UserRoute 2)
              )
              -- user edit
            , ( "UserRoute"
              , configWithPath
              , "http://example.com/users/2/edit"
              , UsersRoutes (UserEditRoute 2)
              )
            , ( "Base: UserRoute"
              , configPathAndBasePath
              , "http://example.com/app/v1/users/2/edit"
              , UsersRoutes (UserEditRoute 2)
              )
            , ( "Hash: UserRoute"
              , configWithHash
              , "http://example.com/#users/2/edit"
              , UsersRoutes (UserEditRoute 2)
              )
            ]

        run ( testCase, currentConfig, href, expected ) =
            test testCase
                <| \() ->
                    let
                        location =
                            { href = href }

                        ( actual, address ) =
                            parseWithUrlParser currentConfig location
                    in
                        Expect.equal expected actual
    in
        describe "UrlParser integration" (List.map run inputs)


all : Test
all =
    describe "Integration"
        [ urlParserIntegrationTest
        ]
