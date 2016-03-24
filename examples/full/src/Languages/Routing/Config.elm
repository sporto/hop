module Languages.Routing.Config (..) where

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Languages.Models exposing (..)


matcherLanguages : PathMatcher Route
matcherLanguages =
  match1 LanguagesRoute ""


matcherLanguage : PathMatcher Route
matcherLanguage =
  match2 LanguageRoute "/" int


matcherLanguageEdit : PathMatcher Route
matcherLanguageEdit =
  match3 LanguageEditRoute "/" int "/edit"


matchers : List (PathMatcher Route)
matchers =
  [ matcherLanguages, matcherLanguage, matcherLanguageEdit ]


toS : a -> String
toS =
  toString



-- Reverse routes


reverseWithPrefix : Route -> String
reverseWithPrefix route =
  "/languages" ++ (reverse route)


reverse : Route -> String
reverse route =
  case route of
    LanguagesRoute ->
      matcherToPath matcherLanguages []

    LanguageRoute id ->
      matcherToPath matcherLanguage [ toS id ]

    LanguageEditRoute id ->
      matcherToPath matcherLanguageEdit [ toS id ]

    NotFoundRoute ->
      ""
