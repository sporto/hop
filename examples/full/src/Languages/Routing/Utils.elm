module Languages.Routing.Utils exposing (..)

import Languages.Models exposing (..)


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

