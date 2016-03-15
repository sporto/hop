module Examples.Basic (..) where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp
import Task exposing (Task)
import Hop
import Hop.Builder exposing (route1)
import Hop.Navigation exposing (navigateTo)


type View
  = About
  | Main
  | NotFound


type Action
  = HopAction ()
  | Show ( View, Hop.Query )
  | NavigateTo String


type alias Model =
  { query : Hop.Query
  , view : View
  }


newModel : Model
newModel =
  { query = router.query
  , view = Main
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    Show ( view, query ) ->
      ( { model | view = view, query = query }, Effects.none )

    HopAction () ->
      ( model, Effects.none )


routes : List (Hop.Route View)
routes =
  [ route1 Main "/"
  , route1 About "/about"
  ]


router : Hop.Router Action
router =
  Hop.new
    { routes = routes
    , action = Show
    , notFound = NotFound
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
  case model.view of
    Main ->
      div [] [ h2 [] [ text "Main" ] ]

    About ->
      div [] [ h2 [] [ text "About" ] ]

    NotFound ->
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
