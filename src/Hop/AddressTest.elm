module Hop.AddressTest exposing (..)

import Dict
import Expect
import Hop.Address as Address
import Hop.Types as Types
import Test exposing (..)


getPathTest : Test
getPathTest =
    let
        inputs =
            [ ( "it works"
              , { path = [ "users", "1" ], query = Dict.singleton "k" "1" }
              , "/users/1"
              )
            , ( "it encodes"
              , { path = [ "us/ers", "1" ], query = Dict.empty }
              , "/us%2Fers/1"
              )
            ]

        run ( testCase, address, expected ) =
            test testCase
                <| \() ->
                    let
                        actual =
                            Address.getPath address
                    in
                        Expect.equal expected actual
    in
        describe "getPath" (List.map run inputs)


getQuery : Test
getQuery =
    let
        inputs =
            [ ( "it works"
              , { path = [], query = Dict.singleton "k" "1" }
              , "?k=1"
              )
            , ( "it encoders"
              , { path = [], query = Dict.singleton "k" "a/b" }
              , "?k=a%2Fb"
              )
            ]

        run ( testCase, address, expected ) =
            test testCase
                <| \() ->
                    let
                        actual =
                            Address.getQuery address
                    in
                        Expect.equal expected actual
    in
        describe "getQuery" (List.map run inputs)


parseTest : Test
parseTest =
    let
        inputs =
            [ ( "it parses"
              , "/users/1?a=1"
              , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
              )
            , ( "it decodes"
              , "/a%2Fb/1?k=x%2Fy"
              , { path = [ "a/b", "1" ], query = Dict.singleton "k" "x/y" }
              )
            ]

        run ( testCase, location, expected ) =
            test testCase
                <| \() ->
                    let
                        actual =
                            Address.parse location
                    in
                        Expect.equal expected actual
    in
        describe "parse" (List.map run inputs)


all : Test
all =
    describe "Location"
        [ getPathTest
        , getQuery
        , parseTest
        ]
