module Examples.Basic where

import Effects exposing (Effects, Never)
import Html as H
import Html.Events exposing(onClick)
import StartApp
import Task exposing(Task)
import Dict
import Hop

type Action
  = HopAction Hop.Action
  | ShowAbout Hop.Payload
  | ShowMain Hop.Payload
  | ShowNotFound Hop.Payload
  | NavigateTo String
  | NoOp

type View
  = Main
  | About
  | NotFound

type alias Model = {
    routerPayload: Hop.Payload,
    view: View
  }
  
newModel : Model
newModel =
  {
    routerPayload = router.payload,
    view = Main
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NavigateTo path ->
      (model, Effects.map HopAction (Hop.navigateTo path))
    ShowMain payload ->
      ({model | view = Main, routerPayload = payload}, Effects.none)
    ShowAbout payload ->
      ({model | view = About, routerPayload = payload}, Effects.none)
    _ ->
      (model, Effects.none)

routes : List (String, Hop.Payload -> Action)
routes =
  [
    ("/", ShowMain),
    ("/about", ShowAbout)
  ]

router : Hop.Router Action
router =
  Hop.new {
    routes = routes,
    notFoundAction = ShowNotFound
  }

init : (Model, Effects Action)
init =
  (newModel, Effects.none)
  
view : Signal.Address Action -> Model -> H.Html
view address model =
  H.div [] [
    menu address model,
    pageView address model
  ]

menu : Signal.Address Action -> Model -> H.Html
menu address model =
  H.div [] [
    H.div [] [
      H.button [
        onClick address (NavigateTo "")
      ] [ H.text "Main" ],
      H.button [
        onClick address (NavigateTo "about")
      ] [ H.text "About" ]
    ]
  ]

pageView : Signal.Address Action -> Model -> H.Html
pageView address model =
  case model.view of
    Main ->
      H.div [] [
        H.h2 [] [ H.text "Main" ]
      ]
    About ->
      H.div [] [
        H.h2 [] [ H.text "About" ]
      ]
    NotFound ->
      H.div [] [
        H.h2 [] [ H.text "Not found" ]
      ]

-- APP

app : StartApp.App Model
app =
  StartApp.start {
    init = init,
    update = update,
    view = view,
    inputs = [router.signal]
  }
  
main: Signal H.Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

port routeRunTask : Task () ()
port routeRunTask =
  router.run
