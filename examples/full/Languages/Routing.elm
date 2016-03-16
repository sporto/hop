module Languages.Routing (..) where

import Effects exposing (Effects)
import Hop.Types exposing (Url, Query, Router)
import Hop.Builder exposing (..)
import Hop.Navigation exposing (navigateTo, setQuery)
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



-- ACTION


type RoutingAction
  = HopAction ()
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
      ( model, Effects.map HopAction (navigateTo path) )

    ApplyRoute ( route, url ) ->
      ( { model | route = route, url = url }, Effects.none )

    HopAction () ->
      ( model, Effects.none )
