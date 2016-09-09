module HopTest exposing (..)

import Expect
import Test exposing (..)
import Hop.TestHelper exposing (configWithHash, configWithPath, configPathAndBasePath)
import Hop


makeResolverTest : Test
makeResolverTest =
    let
        inputs =
            [ ( "path"
              , configWithPath
              , "http://example.com/users/1"
              , "users/1/"
              )
            , ( "path with base"
              , configPathAndBasePath
              , "http://example.com/app/v1/users/1"
              , "users/1/"
              )
            , ( "path"
              , configWithHash
              , "http://example.com/app#/users/1"
              , "users/1/"
              )
            ]

        run ( testCase, config, href, expected ) =
            test testCase
                <| \() ->
                    let
                        resolver =
                            Hop.makeResolver config identity

                        ( actual, _ ) =
                            resolver href
                    in
                        Expect.equal expected actual
    in
        describe "makeResolver" (List.map run inputs)


all : Test
all =
    describe "Hop"
        [ makeResolverTest
        ]
