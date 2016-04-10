module Main (..) where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import StartApp
import Dict
import Task exposing (Task)
import Hop
import Hop.Matchers exposing (..)
import Hop.Navigate exposing (navigateTo, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router, newLocation)


-- ROUTES


type Route
  = AboutRoute
  | MainRoute
  | NotFoundRoute


matchers : List (PathMatcher Route)
matchers =
  [ match1 MainRoute ""
  , match1 AboutRoute "/about"
  ]


routerConfig : Config Route
routerConfig =
  { hash = True
  , basePath = ""
  , matchers = matchers
  , notFound = NotFoundRoute
  }


router : Router Route
router =
  Hop.new routerConfig



-- ACTIONS


type Action
  = HopAction ()
  | ApplyRoute ( Route, Location )
  | NavigateTo String
  | SetQuery Query



-- MODEL


type alias Model =
  { location : Location
  , route : Route
  }


newModel : Model
newModel =
  { location = newLocation
  , route = MainRoute
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case (Debug.log "action" action) of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo routerConfig path) )

    SetQuery query ->
      ( model, Effects.map HopAction (setQuery routerConfig query model.location) )

    ApplyRoute ( route, location ) ->
      ( { model | route = route, location = location }, Effects.none )

    HopAction () ->
      ( model, Effects.none )



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ menu address model
    , pageView address model
    ]


menu : Signal.Address Action -> Model -> Html
menu address model =
  div
    []
    [ div
        []
        [ button
            [ class "btnMain"
            , onClick address (NavigateTo "")
            ]
            [ text "Main" ]
        , button
            [ class "btnAbout"
            , onClick address (NavigateTo "about")
            ]
            [ text "About" ]
        , button
            [ class "btnQuery"
            , onClick address (SetQuery (Dict.singleton "keyword" "elm"))
            ]
            [ text "Set query string" ]
        , currentQuery model
        ]
    ]


currentQuery : Model -> Html
currentQuery model =
  let
    query =
      toString model.location.query
  in
    span
      [ class "labelQuery" ]
      [ text query ]



-- TODO add query here


pageView : Signal.Address Action -> Model -> Html
pageView address model =
  case model.route of
    MainRoute ->
      div [] [ h2 [ class "title" ] [ text "Main" ] ]

    AboutRoute ->
      div [] [ h2 [ class "title" ] [ text "About" ] ]

    NotFoundRoute ->
      div [] [ h2 [ class "title" ] [ text "Not found" ] ]



-- APP


init : ( Model, Effects Action )
init =
  ( newModel, Effects.none )


taggedRouterSignal : Signal Action
taggedRouterSignal =
  Signal.map ApplyRoute router.signal


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ taggedRouterSignal ]
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


port routeRunTask : Task () ()
port routeRunTask =
  router.run
