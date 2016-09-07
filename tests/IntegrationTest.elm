module IntegrationTest exposing (..)

import UrlParser exposing ((</>), oneOf, int, s)
import Expect
import String
import Test exposing (..)
import Hop.TestHelper exposing (config, configWithPath, configPathAndBasePath)
import Hop


type alias LanguageId =
    Int


type LanguageRoute
    = LanguagesRoute
    | LanguageRoute LanguageId
    | LanguageEditRoute LanguageId


type MainRoute
    = HomeRoute
    | AboutRoute
    | LanguagesRoutes LanguageRoute
    | NotFoundRoute


languagesMatchers =
    [ UrlParser.format LanguagesRoute (s "")
    , UrlParser.format LanguageEditRoute (int </> s "edit")
    ]


mainMatchers =
    [ UrlParser.format HomeRoute (s "")
    , UrlParser.format AboutRoute (s "about")
    , UrlParser.format LanguagesRoutes (s "languages" </> (oneOf languagesMatchers))
    ]


routes =
    oneOf mainMatchers


parseWithUrlParser currentConfig location =
    let
        _ =
            Debug.log "parseResult" parseResult

        address =
            location.href
                |> Hop.ingest currentConfig

        path =
            Hop.pathFromAddress address
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
              , config
              , "http://example.com/"
              , HomeRoute
              )
            ]

        run ( testCase, currentConfig, href, expected ) =
            test testCase
                <| \() ->
                    let
                        location =
                            { href = href }

                        (actual, address) =
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
