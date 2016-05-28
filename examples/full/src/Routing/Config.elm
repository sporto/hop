module Routing.Config exposing (..)

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Models exposing (..)
import Languages.Routing.Config


matcherHome : PathMatcher Route
matcherHome =
    match1 HomeRoute ""


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


config : Config Route
config =
    { basePath = "/app"
    , hash = False
    , matchers = matchers
    , notFound = NotFoundRoute
    }
