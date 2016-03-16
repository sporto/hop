module Main (..) where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp
import Task exposing (Task)
import Hop
import Hop.Builder exposing (route1)
import Hop.Navigation exposing (navigateTo)
import Hop.Types exposing (Query, Url, Route, Router)


type AppRoute
  = AboutRoute
  | MainRoute
  | NotFoundRoute


type Action
  = HopAction ()
  | ApplyRoute ( AppRoute, Url )
  | NavigateTo String


type alias Model =
  { url : Url
  , route : AppRoute
  }


newModel : Model
newModel =
  { url = router.url
  , route = MainRoute
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    ApplyRoute ( route, url ) ->
      ( { model | route = route, url = url }, Effects.none )

    HopAction () ->
      ( model, Effects.none )


routes : List (Route AppRoute)
routes =
  [ route1 MainRoute "/"
  , route1 AboutRoute "/about"
  ]


router : Router Action
router =
  Hop.new
    { routes = routes
    , action = ApplyRoute
    , notFound = NotFoundRoute
    }


init : ( Model, Effects Action )
init =
  ( newModel, Effects.none )


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


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ router.signal ]
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
