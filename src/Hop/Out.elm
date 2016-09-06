module Hop.Out exposing (..)

import String
import Hop.Types exposing (Config)
import Hop.Utils exposing (dedupSlash)
import Hop.Address exposing (parse)


{-|
Make a real path from a simulated path.
This will add the hash and the basePath as necessary.

    toRealPath config "/users"

    ==

    "#/users"
-}
outputFromPath : Config -> String -> String
outputFromPath config path =
    path
        |> Hop.Address.parse
        |> output config


{-|
Make a real path from an address record.
This will add the hash and the basePath as necessary.

    fromAddress config { path = ["users", "1"], query = Dict.empty }

    ==

    "#/users/1"

-}
output : Config -> Hop.Types.Address -> String
output config address =
    let
        joined =
            String.join "/" address.path

        query =
            Hop.Address.getQuery address

        url =
            if config.hash then
                "#/" ++ joined ++ query
            else if String.isEmpty config.basePath then
                "/" ++ joined ++ query
            else if String.isEmpty joined then
                "/" ++ config.basePath ++ query
            else
                "/" ++ config.basePath ++ "/" ++ joined ++ query

        realPath =
            dedupSlash url
    in
        if realPath == "" then
            "/"
        else
            realPath
