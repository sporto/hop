module Hop.Real exposing (..)

import String
import Regex
import Hop.Types
import Hop.Address
import Hop.Utils exposing (dedupSlash)


{-|
Make a real path from an address record.
This will add the hash and the basePath as necessary.

    fromAddress config { path = ["users", "1"], query = Dict.empty }

    ==

    "#/users/1"

-}
fromAddress : Hop.Types.Config route -> Hop.Types.Address -> String
fromAddress config address =
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
