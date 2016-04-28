module Routing.Utils (..) where

import Hop.Matchers exposing (..)
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
