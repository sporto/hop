module Routing.Utils exposing (..)

import Hop exposing (matcherToPath)
import Models exposing (..)
import Routing.Config exposing (..)
import Users.Routing.Utils


reverse : Route -> String
reverse route =
    case route of
        HomeRoute ->
            matcherToPath matcherHome []

        AboutRoute ->
            matcherToPath matcherAbout []

        UsersRoutes subRoute ->
            let
                parentPath =
                    matcherToPath matchersUsers []

                subPath =
                    Users.Routing.Utils.reverse subRoute
            in
                parentPath ++ subPath

        NotFoundRoute ->
            ""
