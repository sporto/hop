module Languages.Routing exposing (..)

import Languages.Models exposing (..)
import UrlParser exposing ((</>), int, s, string)


matchers : List (UrlParser.Parser (Route -> a) a)
matchers =
    [ UrlParser.format LanguageEditRoute (int </> s "edit")
    , UrlParser.format LanguageRoute (int)
    , UrlParser.format LanguagesRoute (s "")
    ]


toS : a -> String
toS =
    toString


reverseWithPrefix : Route -> String
reverseWithPrefix route =
    "/languages" ++ (reverse route)


reverse : Route -> String
reverse route =
    case route of
        LanguagesRoute ->
            "/"

        LanguageRoute id ->
            "/" ++ (toS id)

        LanguageEditRoute id ->
            "/" ++ (toS id) ++ "/edit"
