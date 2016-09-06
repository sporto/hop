module Hop.InTest exposing (..)

import Dict
import Expect
import Hop.In exposing (ingest)
import Test exposing (..)

type Route
    = NotFound


config =
    { hash = True
    , basePath = ""
    }


configWithPath =
    { config | hash = False }


configWithPathAndBase =
    { configWithPath | basePath = "/app/v1" }


inputTest : Test
inputTest =
    let
        inputs =
            [ ( "it parses an empty hash"
              , config
              , "http://localhost:3000/basepath"
              , { path = [], query = Dict.empty }
              )
            , ( "it parses a hash"
              , config
              , "http://localhost:3000/basepath#/users/1"
              , { path = [ "users", "1" ], query = Dict.empty }
              )
            , ( "it parses a path"
              , configWithPath
              , "http://localhost:3000/users/1"
              , { path = [ "users", "1" ], query = Dict.empty }
              )
            , ( "it parses a path with basepath"
              , configWithPathAndBase
              , "http://localhost:3000/app/v1/users/1"
              , { path = [ "users", "1" ], query = Dict.empty }
              )
            , ( "it parses a hash with query"
              , config
              , "http://localhost:3000/basepath#/users/1?a=1"
              , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
              )
            , ( "it parses a path with query"
              , configWithPath
              , "http://localhost:3000/users/1?a=1"
              , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
              )
            , ( "it parses a path with basepath and query"
              , configWithPathAndBase
              , "http://localhost:3000/app/v1/users/1?a=1"
              , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
              )
            , ( "it decodes the query"
              , config
              , "http://localhost:3000/basepath#/?a%20b%26c%3Fd=1%202%263%3F4"
              , { path = [], query = Dict.singleton "a b&c?d" "1 2&3?4" }
              )
            ]

        run ( testCase, config, href, expected ) =
            test testCase
                <| \() ->
                    let
                        actual =
                            ingest config href
                    in
                        Expect.equal expected actual
    in
        describe "ingest" (List.map run inputs)


all : Test
all =
    describe "In"
        [ inputTest
        ]
