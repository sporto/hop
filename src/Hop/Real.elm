module Hop.Real exposing(..)

import String
import Regex
import Hop.Types
import Hop.Address
import Hop.Utils exposing (dedupSlash)

{-|
Return only the relevant part of a location string depending on the configuration

    http://localhost:3000/app/languages?k=1 --> /app/languages?k=1
-}
toSimulated : Hop.Types.Config route -> String -> String
toSimulated config href =
    let
        withoutProtocol =
            href
                |> String.split "//"
                |> List.reverse
                |> List.head
                |> Maybe.withDefault ""

        withoutDomain =
            withoutProtocol
                |> String.split "/"
                |> List.tail
                |> Maybe.withDefault []
                |> String.join "/"
                |> String.append "/"
    in
        if config.hash then
            withoutDomain
                |> String.split "#"
                |> List.drop 1
                |> List.head
                |> Maybe.withDefault ""
        else
            withoutDomain
                |> String.split "#"
                |> List.head
                |> Maybe.withDefault ""
                |> locationStringWithoutBase config

{-| @priv
Remove the basePath from a path

"/basepath/a/b?k=1" -> "/a/b?k=1"
-}
locationStringWithoutBase : Hop.Types.Config route -> String -> String
locationStringWithoutBase config locationString =
    let
        regex =
            Regex.regex config.basePath
    in
        Regex.replace (Regex.AtMost 1) regex (always "") locationString


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
