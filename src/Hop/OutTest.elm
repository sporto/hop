module Hop.OutTest exposing (..)

import Dict
import Expect
import Hop.Out as Out
import Hop.Types exposing (newAddress)
import Test exposing (..)


outputTest : Test
outputTest =
    let
        config =
            { basePath = ""
            , hash = True
            }

        configWithPath =
            { config | hash = False }

        configPathAndBasePath =
            { configWithPath | basePath = "/app/v1" }

        empty =
            newAddress

        inputs =
            [ ( "hash: it is empty when empty"
              , config
              , empty
              , "#/"
              )
            , ( "path: it is empty when empty"
              , configWithPath
              , empty
              , "/"
              )
            , ( "basepath: it has the basepath"
              , configPathAndBasePath
              , empty
              , "/app/v1"
              )
            , ( "basepath: adds slash when missing"
              , { configPathAndBasePath | basePath = "app/v1" }
              , empty
              , "/app/v1"
              )
              -- path
            , ( "hash: it adds the path"
              , config
              , { empty | path = [ "a", "b" ] }
              , "#/a/b"
              )
            , ( "path: it adds the path"
              , configWithPath
              , { empty | path = [ "a", "b" ] }
              , "/a/b"
              )
            , ( "path: it adds the basepath and path"
              , configPathAndBasePath
              , { empty | path = [ "a", "b" ] }
              , "/app/v1/a/b"
              )
              -- query
            , ( "hash: it adds the query as pseudo query"
              , config
              , { empty | query = Dict.singleton "k" "1" }
              , "#/?k=1"
              )
            , ( "path: it adds the query"
              , configWithPath
              , { empty | query = Dict.singleton "k" "1" }
              , "/?k=1"
              )
            , ( "path: it adds the basepath query"
              , configPathAndBasePath
              , { empty | query = Dict.singleton "k" "1" }
              , "/app/v1?k=1"
              )
              -- path and query
            , ( "hash: it adds the path and query"
              , config
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "#/a/b?k=1"
              )
            , ( "path: it adds the path and query"
              , configWithPath
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "/a/b?k=1"
              )
            , ( "path: it adds the basepath, path and query"
              , configPathAndBasePath
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "/app/v1/a/b?k=1"
              )
            , ( "hash: it encodes"
              , config
              , { empty | query = Dict.singleton "a b&c?d" "1 2&3?4", path = [] }
              , "#/?a%20b%26c%3Fd=1%202%263%3F4"
              )
            ]

        run ( testCase, config, location, expected ) =
            test testCase
                <| \() ->
                    let
                        actual =
                            Out.output config location
                    in
                        Expect.equal expected actual
    in
        describe "locationToFullPath" (List.map run inputs)

# TODO OUTPUT FROM PATH

all : Test
all =
    describe "In"
        [ outputTest
        ]
