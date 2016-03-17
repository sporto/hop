module Languages.Routing (..) where

import Effects exposing (Effects)
import Hop.Types exposing (Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Hop.Navigate exposing (navigateTo, setQuery)
import Languages.Models exposing (..)


-- ROUTES


type Route
  = LanguagesRoute
  | LanguageRoute LanguageId
  | LanguageEditRoute LanguageId
  | NotFoundRoute


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



-- ACTION


type Action
  = RoutingHopAction ()
  | ApplyRoute ( Route, Location )
  | NavigateTo String



-- MODEL


type alias Model =
  { location : Location
  , route : Route
  }


newModel : Model
newModel =
  { location = newLocation
  , route = LanguagesRoute
  }



-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map RoutingHopAction (navigateTo path) )

    ApplyRoute ( route, location ) ->
      ( { model | route = route, location = location }, Effects.none )

    RoutingHopAction () ->
      ( model, Effects.none )
