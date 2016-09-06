module Routing.Utils exposing (..)

import Models exposing (..)
import Languages.Routing.Utils


reverse : Route -> String
reverse route =
    case route of
        HomeRoute ->
            ""

        AboutRoute ->
            "about"

        LanguagesRoutes subRoute ->
            "languages" ++ Languages.Routing.Utils.reverse subRoute

        NotFoundRoute ->
            ""
