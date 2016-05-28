module Languages.Routing.Config exposing (..)

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
