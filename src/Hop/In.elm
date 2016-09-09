module Hop.In exposing (..)

import Regex
import String
import Hop.Types exposing (Address, Config)
import Hop.Address exposing (parse)


{-| @priv
-}
ingest : Config -> String -> Address
ingest config href =
    href
        |> removeProtocol
        |> removeDomain
        |> getRelevantPathWithQuery config
        |> parse


{-| @priv
-}
removeProtocol : String -> String
removeProtocol href =
    href
        |> String.split "//"
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""


{-| @priv
-}
removeDomain : String -> String
removeDomain href =
    href
        |> String.split "/"
        |> List.tail
        |> Maybe.withDefault []
        |> String.join "/"
        |> String.append "/"


{-| @priv
-}
getRelevantPathWithQuery : Config -> String -> String
getRelevantPathWithQuery config href =
    if config.hash then
        href
            |> String.split "#"
            |> List.drop 1
            |> List.head
            |> Maybe.withDefault ""
    else
        href
            |> String.split "#"
            |> List.head
            |> Maybe.withDefault ""
            |> removeBase config


{-| @priv
Remove the basePath from a path

"/basepath/a/b?k=1" -> "/a/b?k=1"
-}
removeBase : Config -> String -> String
removeBase config pathWithQuery =
    let
        regex =
            Regex.regex config.basePath
    in
        Regex.replace (Regex.AtMost 1) regex (always "") pathWithQuery
