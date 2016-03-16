module Routing (..) where

import Effects exposing (Effects)
import Hop
import Hop.Types exposing (Url, Query, Router)
import Hop.Builder exposing (..)
import Hop.Navigation exposing (navigateTo, setQuery)
import Hop.Matcher exposing (routeToPath)
import Languages.Routing


--import Languages.Models exposing (LanguageId)

import Languages.Routing


-- ROUTES


type Route
  = HomeRoute
  | AboutRoute
  | LanguagesRoutes Languages.Routing.Route
  | NotFoundRoute


routeHome : Hop.Types.Route Route
routeHome =
  route1 HomeRoute "/"


routeAbout : Hop.Types.Route Route
routeAbout =
  route1 AboutRoute "/about"


routesLanguages : Hop.Types.Route Route
routesLanguages =
  nested1 LanguagesRoutes "/languages" Languages.Routing.routes


routes : List (Hop.Types.Route Route)
routes =
  [ routeHome
  , routeAbout
  , routesLanguages
  ]


reverse : Route -> String
reverse route =
  case route of
    HomeRoute ->
      routeToPath routeHome []

    AboutRoute ->
      routeToPath routeAbout []

    LanguagesRoutes subRoute ->
      let
        parentPath =
          routeToPath routesLanguages []

        subPath =
          Languages.Routing.reverse subRoute
      in
        parentPath ++ subPath

    NotFoundRoute ->
      ""



-- ACTION


type RoutingAction
  = HopAction ()
  | ApplyRoute ( Route, Url )
  | NavigateTo String
  | SetQuery Query
  | RoutingLanguagesAction Languages.Routing.RoutingAction



-- MODEL


type alias Model =
  { url : Url
  , route : Route
  , languagesRouting : Languages.Routing.Model
  }


newModel : Model
newModel =
  { url = router.url
  , route = AboutRoute
  , languagesRouting = Languages.Routing.newModel router.url
  }



-- ROUTER


router : Hop.Types.Router RoutingAction
router =
  Hop.new
    { routes = routes
    , action = ApplyRoute
    , notFound = NotFoundRoute
    }



-- UPDATE


update : RoutingAction -> Model -> ( Model, Effects RoutingAction )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    ApplyRoute ( route, url ) ->
      case route of
        LanguagesRoutes subRoute ->
          let
            showAction =
              Languages.Routing.ApplyRoute ( subRoute, url )

            ( updatedLanguagesModel, fx ) =
              Languages.Routing.update showAction model.languagesRouting
          in
            ( { model | route = route, url = url, languagesRouting = updatedLanguagesModel }, Effects.map RoutingLanguagesAction fx )

        _ ->
          ( { model | route = route, url = url }, Effects.none )

    RoutingLanguagesAction subAction ->
      let
        ( updatedLanguagesModel, fx ) =
          Languages.Routing.update subAction model.languagesRouting
      in
        ( { model | languagesRouting = updatedLanguagesModel }, Effects.map RoutingLanguagesAction fx )

    SetQuery query ->
      ( model, Effects.map HopAction (setQuery query model.url) )

    HopAction () ->
      ( model, Effects.none )
