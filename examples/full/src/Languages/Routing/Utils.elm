module Languages.Routing.Utils exposing (..)

-- import Hop.Types exposing (Config)
import Languages.Models exposing (..)
import Routing.Config



-- config : Config
-- config =
--     Routing.Config.config


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
            "/languages"

        LanguageRoute id ->
            "/languages/" ++ (toS id)

        LanguageEditRoute id ->
            "/languages/" ++ (toS id) ++ "/edit"

        NotFoundRoute ->
            ""
