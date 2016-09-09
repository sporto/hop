module Hop.Out exposing (..)

import String
import Hop.Types exposing (Address, Config)
import Hop.Utils exposing (dedupSlash)
import Hop.Address exposing (parse)


{-|
Make a real path from an address record.
This will add the hash and the basePath as necessary.

    fromAddress config { path = ["users", "1"], query = Dict.empty }

    ==

    "#/users/1"

-}
output : Config -> Address -> String
output config address =
    let
        -- path -> "/a/1"
        path =
            Hop.Address.getPath address

        -- query -> "?a=1"
        query =
            Hop.Address.getQuery address

        url =
            if config.hash then
                "#" ++ path ++ query
            else if String.isEmpty config.basePath then
                path ++ query
            else if path == "/" then
                "/" ++ config.basePath ++ query
            else
                "/" ++ config.basePath ++ path ++ query

        realPath =
            dedupSlash url
    in
        if realPath == "" then
            "/"
        else
            realPath


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
