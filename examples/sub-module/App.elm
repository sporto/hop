module Examples.Basic.App where

import Html as H
import Html.Events
import Dict
import Debug
import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href, style)
import Task exposing (Task)
import Debug
import Hop

type alias Model = {
    routerPayload: Hop.Payload,
    view: String
  }


zeroModel : Model
zeroModel =
  {
    routerPayload = router.payload,
    view = "Main"
  }

type Action
  = HopAction Hop.Action
  | ShowAbout Hop.Payload
  | ShowMain Hop.Payload
  | ShowContact Hop.Payload
  | ShowNotFound Hop.Payload

init: (Model, Effects Action)
init =
  (zeroModel, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ShowMain payload ->
      ({model | view = "main", routerPayload = payload}, Effects.none)
    ShowAbout payload ->
      ({model | view = "about", routerPayload = payload}, Effects.none)
    ShowContact payload ->
      ({model | view = "contact", routerPayload = payload}, Effects.none)
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
  case model.view of
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

routes : List (String, Hop.Payload -> Action)
routes =
  [
    ("/", ShowMain),
    ("/main", ShowMain),
    ("/about", ShowAbout),
    ("/contact", ShowContact)
  ]

router : Hop.Router Action
router = 
  Hop.new {
    routes = routes,
    notFoundAction = ShowNotFound
  }

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
