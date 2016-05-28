module Languages.Routing.Utils exposing (..)

import Hop exposing (..)
import Hop.Types exposing (Config)
import Models
import Languages.Models exposing (..)
import Routing.Config
import Languages.Routing.Config exposing (..)


config : Config Models.Route
config =
    Routing.Config.config


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
            matcherToPath matcherLanguages []

        LanguageRoute id ->
            matcherToPath matcherLanguage [ toS id ]

        LanguageEditRoute id ->
            matcherToPath matcherLanguageEdit [ toS id ]

        NotFoundRoute ->
            ""
