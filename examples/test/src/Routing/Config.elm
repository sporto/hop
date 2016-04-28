module Routing.Config (..) where

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Models exposing (..)
import Users.Routing.Config


matcherHome : PathMatcher Route
matcherHome =
  match1 HomeRoute ""


matcherAbout : PathMatcher Route
matcherAbout =
  match1 AboutRoute "/about"


matchersUsers : PathMatcher Route
matchersUsers =
  nested1 UsersRoutes "/users" Users.Routing.Config.matchers


matchers : List (PathMatcher Route)
matchers =
  [ matcherHome
  , matcherAbout
  , matchersUsers
  ]


config : Config Route
config =
  { basePath = ""
  , hash = True
  , matchers = matchers
  , notFound = NotFoundRoute
  }
