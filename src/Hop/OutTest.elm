module Hop.OutTest exposing (..)

import Dict
import Expect
import Hop.Out as Out
import Hop.Types exposing (newAddress)
import Hop.TestHelper exposing (config, configWithPath, configPathAndBasePath)
import Test exposing (..)


outputTest : Test
outputTest =
    let
        empty =
            newAddress

        inputs =
            [ ( "hash: it is empty when empty"
              , config
              , empty
              , ""
              , "#/"
              )
            , ( "path: it is empty when empty"
              , configWithPath
              , empty
              , ""
              , "/"
              )
            , ( "basepath: it has the basepath"
              , configPathAndBasePath
              , empty
              , ""
              , "/app/v1"
              )
            , ( "basepath: adds slash when missing"
              , { configPathAndBasePath | basePath = "app/v1" }
              , empty
              , ""
              , "/app/v1"
              )
              -- path
            , ( "hash: it adds the path"
              , config
              , { empty | path = [ "a", "b" ] }
              , "/a/b"
              , "#/a/b"
              )
            , ( "path: it adds the path"
              , configWithPath
              , { empty | path = [ "a", "b" ] }
              , "/a/b"
              , "/a/b"
              )
            , ( "path: it adds the basepath and path"
              , configPathAndBasePath
              , { empty | path = [ "a", "b" ] }
              , "/a/b"
              , "/app/v1/a/b"
              )
              -- query
            , ( "hash: it adds the query as pseudo query"
              , config
              , { empty | query = Dict.singleton "k" "1" }
              , "?k=1"
              , "#/?k=1"
              )
            , ( "path: it adds the query"
              , configWithPath
              , { empty | query = Dict.singleton "k" "1" }
              , "?k=1"
              , "/?k=1"
              )
            , ( "path: it adds the basepath query"
              , configPathAndBasePath
              , { empty | query = Dict.singleton "k" "1" }
              , "?k=1"
              , "/app/v1?k=1"
              )
              -- path and query
            , ( "hash: it adds the path and query"
              , config
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "/a/b?k=1"
              , "#/a/b?k=1"
              )
            , ( "path: it adds the path and query"
              , configWithPath
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "/a/b?k=1"
              , "/a/b?k=1"
              )
            , ( "path: it adds the basepath, path and query"
              , configPathAndBasePath
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "/a/b?k=1"
              , "/app/v1/a/b?k=1"
              )
            , ( "hash: it encodes"
              , config
              , { empty | query = Dict.singleton "a/d" "1/4", path = [ "a/b", "1" ] }
              , "/a%2Fb/1?a%2Fd=1%2F4"
              , "#/a%2Fb/1?a%2Fd=1%2F4"
              )
            ]

        run ( testCase, config, address, path, expected ) =
            [ test testCase
                <| \() ->
                    let
                        actual =
                            Out.output config address
                    in
                        Expect.equal expected actual
            , test testCase
                <| \() ->
                    let
                        actual =
                            Out.outputFromPath config path
                    in
                        Expect.equal expected actual
            ]
        
        tests =
            List.concatMap  run inputs
    in
        describe "output and outputFromPath" tests


all : Test
all =
    describe "In"
        [ outputTest
        ]
