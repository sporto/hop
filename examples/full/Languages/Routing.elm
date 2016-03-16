module Languages.Routing (..) where

import Debug
import Effects exposing (Effects)
import Hop.Types exposing (Url, Query, Router)
import Hop.Builder exposing (..)
import Hop.Navigation exposing (navigateTo, setQuery)
import Hop.Matcher exposing (routeToPath)
import Languages.Models exposing (..)


-- ROUTES


type Route
  = LanguagesRoute
  | LanguageRoute LanguageId
  | LanguageEditRoute LanguageId
  | NotFoundRoute


routeLanguages : Hop.Types.Route Route
routeLanguages =
  route1 LanguagesRoute ""


routeLanguage : Hop.Types.Route Route
routeLanguage =
  route2 LanguageRoute "/" int


routeLanguageEdit : Hop.Types.Route Route
routeLanguageEdit =
  route3 LanguageEditRoute "/" int "/edit"


routes : List (Hop.Types.Route Route)
routes =
  [ routeLanguages, routeLanguage, routeLanguageEdit ]


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
      routeToPath routeLanguages []

    LanguageRoute id ->
      routeToPath routeLanguage [ toS id ]

    LanguageEditRoute id ->
      routeToPath routeLanguageEdit [ toS id ]

    NotFoundRoute ->
      ""



-- ACTION


type RoutingAction
  = RoutingHopAction ()
  | ApplyRoute ( Route, Url )
  | NavigateTo String



-- MODEL


type alias Model =
  { url : Url
  , route : Route
  }


newModel : Url -> Model
newModel url =
  { url = url
  , route = LanguagesRoute
  }



-- UPDATE


update : RoutingAction -> Model -> ( Model, Effects RoutingAction )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map RoutingHopAction (navigateTo path) )

    ApplyRoute ( route, url ) ->
      ( { model | route = route, url = url }, Effects.none )

    RoutingHopAction () ->
      ( model, Effects.none )
