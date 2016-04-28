module Users.Routing.Utils (..) where

import Hop.Matchers exposing (..)
import Hop.Types exposing (Config)
import Models
import Users.Models exposing (..)
import Routing.Config
import Users.Routing.Config exposing (..)


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
    UsersRoute ->
      matcherToPath matcherUsers []

    UserRoute id ->
      matcherToPath matcherUser [ toS id ]

    UserStatusRoute id ->
      matcherToPath matcherUserStatus [ toS id ]

    NotFoundRoute ->
      ""
