module Hop.In exposing (..)

import Regex
import String
import Hop.Types
import Hop.Address exposing (parse)


{-|
In
-}
ingest : Hop.Types.Config route -> String -> Hop.Types.Address
ingest config href =
    href
        |> removeProtocol
        |> removeDomain
        |> getRelevantPathWithQuery config
        |> parse


removeProtocol href =
    href
        |> String.split "//"
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""


removeDomain href =
    href
        |> String.split "/"
        |> List.tail
        |> Maybe.withDefault []
        |> String.join "/"
        |> String.append "/"


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
removeBase config pathWithQuery =
    let
        regex =
            Regex.regex config.basePath
    in
        Regex.replace (Regex.AtMost 1) regex (always "") pathWithQuery
