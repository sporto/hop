module Routing.Utils exposing (..)

import Hop exposing (..)
import Models exposing (..)
import Routing.Config exposing (..)
import Languages.Routing.Utils


reverse : Route -> String
reverse route =
    case route of
        HomeRoute ->
            matcherToPath matcherHome []

        AboutRoute ->
            matcherToPath matcherAbout []

        LanguagesRoutes subRoute ->
            let
                parentPath =
                    matcherToPath matchersLanguages []

                subPath =
                    Languages.Routing.Utils.reverse subRoute
            in
                parentPath ++ subPath

        NotFoundRoute ->
            ""
