module Examples.SubModule.App where

import Html as H
import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href, style)
import Task exposing (Task)
import Debug

import Examples.SubModule.Routing as Routing exposing(router)

type alias Model = {
    routing: Routing.Model
  }

zeroModel : Model
zeroModel = {
    routing = Routing.zeroModel
  }

type Action
  = NoOp
  | RoutingAction Routing.Action

init: (Model, Effects Action)
init =
  (zeroModel, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    RoutingAction subAction ->
      let
        (updatedRouting, fx) =
          Routing.update subAction model.routing
      in
        ({model | routing = updatedRouting }, Effects.map RoutingAction fx)
    _ ->
      (model, Effects.none)

view : Signal.Address Action -> Model -> H.Html
view address model =
  H.div [] [
    menu address model,
    page address model
  ]

menu : Signal.Address Action -> Model -> H.Html
menu address model =
  H.div [] [
    H.a [ href "#/main" ] [ H.text "Main" ],
    H.a [ href "#/about" ] [ H.text "About" ],
    H.a [ href "#/contact" ] [ H.text "Contact" ]
  ]

page : Signal.Address Action -> Model -> H.Html
page address model =
  case model.routing.view of
    "main" ->
      H.div [] [
        H.text "Main"
      ]
    "about" ->
      H.div [] [
        H.text "About"
      ]
    "contact" ->
      H.div [] [
        H.text "Contact"
      ]
    _ ->
      H.div [] [
        H.text "Not found"
      ]

notFoundView: Signal.Address Action -> Model -> H.Html
notFoundView address model =
  H.div [] [
    H.text "Not Found"
  ]

routerSignal =
  Signal.map RoutingAction router.signal

app : StartApp.App Model
app =
  StartApp.start {
    init = init,
    update = update,
    view = view,
    inputs = [routerSignal]
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
