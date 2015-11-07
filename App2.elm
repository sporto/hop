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
  | RouteChanged (Result () ())
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

hashChangeSignal: Signal Action
hashChangeSignal =
  Signal.map (Debug.watch "dff") routerMailbox.signal

app =
  StartApp.start {
    init = init,
    update = update,
    view = (view routerMailbox.address),
    inputs = [hashChangeSignal]
  }


-- Effects

goToRoute: String -> (Effects Action)
goToRoute route =
  History.setPath route
    |> Task.toResult
    |> Task.map RouteChanged
    |> Effects.task

--debugSignal: Signal (a -> a)
--debugSignal =
--  Signal.map Debug.watch (Signal.map toString routerMailbox.signal)
  --Signal.map (Debug.watch toString) routerMailbox.signal

--debugSignalFw =
--  Signal.forwardTo 

--port fooPort: Signal String
--port fooPort =
--  Signal.map toString debugSignal

{-
 1. click button
 2. send hash change message to address in routerMailbox
 3. mailbox sends change signal
 4. change hash

 5. React to hash change
 6. send signal with changed address
 7. update route model
 8. update views (need to receive route model)
-}

main: Signal H.Html
main =
  app.html

-- this is the important bit
port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
  

