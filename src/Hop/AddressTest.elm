module Hop.AddressTest exposing (..)

import Dict
import Expect
import Hop.Address as Address
import Hop.Types as Types
import Test exposing (..)


parseTest : Test
parseTest =
    let
        inputs =
            [ ( "it parses", "/users/1?a=1", { path = [ "users", "1" ], query = Dict.singleton "a" "1" } )
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
        [ parseTest
        ]
