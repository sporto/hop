module Hop.Out exposing (..)

import String
import Regex
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
outgestFromPath : Config route -> String -> String
outgestFromPath config path =
    path
        |> Hop.Address.parse
        |> outgest config


{-|
Make a real path from an address record.
This will add the hash and the basePath as necessary.

    fromAddress config { path = ["users", "1"], query = Dict.empty }

    ==

    "#/users/1"

-}
outgest : Hop.Types.Config route -> Hop.Types.Address -> String
outgest config address =
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
