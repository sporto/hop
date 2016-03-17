module Main (..) where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp
import Task exposing (Task)
import Hop
import Hop.Matchers exposing (..)
import Hop.Navigate exposing (navigateTo)
import Hop.Types exposing (Query, Location, PathMatcher, Router, newLocation)


-- ROUTES


type Route
  = AboutRoute
  | MainRoute
  | NotFoundRoute


matchers : List (PathMatcher Route)
matchers =
  [ match1 MainRoute "/"
  , match1 AboutRoute "/about"
  ]


router : Router Route
router =
  Hop.new
    { matchers = matchers
    , notFound = NotFoundRoute
    }



-- ACTIONS


type Action
  = HopAction ()
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
  , route = MainRoute
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

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
            [ onClick address (NavigateTo "")
            ]
            [ text "Main" ]
        , button
            [ onClick address (NavigateTo "about")
            ]
            [ text "About" ]
        ]
    ]


pageView : Signal.Address Action -> Model -> Html
pageView address model =
  case model.route of
    MainRoute ->
      div [] [ h2 [] [ text "Main" ] ]

    AboutRoute ->
      div [] [ h2 [] [ text "About" ] ]

    NotFoundRoute ->
      div [] [ h2 [] [ text "Not found" ] ]



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
