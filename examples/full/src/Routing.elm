module Routing (..) where

import Task exposing (Task)
import Effects exposing (Effects)
import Hop
import Hop.Types exposing (Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Hop.Navigate exposing (navigateTo, setQuery)
import Languages.Routing


--import Languages.Models exposing (LanguageId)

import Languages.Routing


-- ROUTES


type Route
  = HomeRoute
  | AboutRoute
  | LanguagesRoutes Languages.Routing.Route
  | NotFoundRoute


matcherHome : PathMatcher Route
matcherHome =
  match1 HomeRoute "/"


matcherAbout : PathMatcher Route
matcherAbout =
  match1 AboutRoute "/about"


matchersLanguages : PathMatcher Route
matchersLanguages =
  nested1 LanguagesRoutes "/languages" Languages.Routing.matchers


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
          Languages.Routing.reverse subRoute
      in
        parentPath ++ subPath

    NotFoundRoute ->
      ""



-- ACTION


type Action
  = HopAction ()
  | ApplyRoute ( Route, Location )
  | NavigateTo String
  | SetQuery Query
  | RoutingLanguagesAction Languages.Routing.Action



-- MODEL


type alias Model =
  { location : Location
  , route : Route
  , languagesRouting : Languages.Routing.Model
  }


newModel : Model
newModel =
  { location = newLocation
  , route = AboutRoute
  , languagesRouting = Languages.Routing.newModel
  }



-- ROUTER


router : Router Route
router =
  Hop.new
    { matchers = matchers
    , notFound = NotFoundRoute
    }


signal : Signal Action
signal =
  Signal.map ApplyRoute router.signal



-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    ApplyRoute ( route, location ) ->
      case route of
        LanguagesRoutes subRoute ->
          let
            showAction =
              Languages.Routing.ApplyRoute ( subRoute, location )

            ( updatedLanguagesModel, fx ) =
              Languages.Routing.update showAction model.languagesRouting
          in
            ( { model | route = route, location = location, languagesRouting = updatedLanguagesModel }, Effects.map RoutingLanguagesAction fx )

        _ ->
          ( { model | route = route, location = location }, Effects.none )

    RoutingLanguagesAction subAction ->
      let
        ( updatedLanguagesModel, fx ) =
          Languages.Routing.update subAction model.languagesRouting
      in
        ( { model | languagesRouting = updatedLanguagesModel }, Effects.map RoutingLanguagesAction fx )

    SetQuery query ->
      ( model, Effects.map HopAction (setQuery query model.location) )

    HopAction () ->
      ( model, Effects.none )


run : Task () ()
run =
  router.run
