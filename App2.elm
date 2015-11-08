-- Try to integrate wih start app

module App where

import Html as H
import Html.Events
import Debug

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href)
import History
import Task exposing (Task)

type alias AppModel = {
  count: Int
}
                      
zeroModel: AppModel
zeroModel =
  {
    count = 1
  }

type Action
  = ChangeRoute String
  | ChangeRouteResult (Result () ())
  | RouteChanged String
  | Increment
  | NoOp

init: (AppModel, Effects Action)
init =
  (zeroModel, Effects.none)

update: Action -> AppModel -> (AppModel, Effects Action)
update action model =
  case action of
    Increment ->
      ({model | count <- model.count + 1 }, Effects.none)
    ChangeRoute route ->
      (model, goToRoute route)
    RouteChanged result ->
      ({model | count <- model.count + 1 }, Effects.none)
    _ ->
      (model, Effects.none)

view: Signal.Address Action -> Signal.Address Action -> AppModel -> H.Html
view routerAddress address model =
  H.div [] [
    H.text "Hello",
    H.text (toString model.count)
    , menu routerAddress address model
  ]

menu: Signal.Address Action -> Signal.Address Action -> AppModel -> H.Html
menu routerAddress address model =
  H.div [] [
    H.button [ Html.Events.onClick address (Increment) ] [
      H.text "Count"
    ],
    H.button [ Html.Events.onClick routerAddress (ChangeRoute "#users") ] [
      H.text "Users"
    ],
    H.button [ Html.Events.onClick routerAddress (ChangeRoute "#users/1") ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1" ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1/edit" ] [
      H.text "User 1 edit"
    ]
  ]

-- ROUTING

--type RouteAction
--  = Nothing

routerMailbox: Signal.Mailbox Action
routerMailbox = Signal.mailbox NoOp

--hashChangeSignal: Signal Action
--hashChangeSignal =
--  Signal.map (Debug.watch "dff") routerMailbox.signal

hashChangeSignal: Signal Action
hashChangeSignal =
  Signal.map  (\s -> RouteChanged s) History.hash

app =
  StartApp.start {
    init = init,
    update = update,
    view = (view routerMailbox.address),
    inputs = [routerMailbox.signal, hashChangeSignal]
  }

-- Effects

-- Maybe this should return Effects.none
goToRoute: String -> (Effects Action)
goToRoute route =
  History.setPath route
    |> Task.toResult
    |> Task.map ChangeRouteResult
    |> Effects.task

main: Signal H.Html
main =
  app.html

-- this is the important bit
port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
  
--port history : 
--port history = 


