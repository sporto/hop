module Routing.Config (..) where

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Models exposing (..)
import Languages.Routing.Config


matcherHome : PathMatcher Route
matcherHome =
  match1 HomeRoute "/"


matcherAbout : PathMatcher Route
matcherAbout =
  match1 AboutRoute "/about"


matchersLanguages : PathMatcher Route
matchersLanguages =
  nested1 LanguagesRoutes "/languages" Languages.Routing.Config.matchers


matchers : List (PathMatcher Route)
matchers =
  [ matcherHome
  , matcherAbout
  , matchersLanguages
  ]


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
          Languages.Routing.Config.reverse subRoute
      in
        parentPath ++ subPath

    NotFoundRoute ->
      ""


config : Config Route
config =
  { hash = True
  , matchers = matchers
  , notFound = NotFoundRoute
  }
