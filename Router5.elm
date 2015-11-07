module Router5 where

import Html as H
import Html.Events

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href)

type alias AppModel = {
  count: Int
}
                      
zeroModel: AppModel
zeroModel =
  {
    count = 1
  }

type ExtAction
  = ChangeRoute String
  | NoOp

type Action
  = DoNothing
  | ShowUsers

init: (AppModel, Effects Action)
init =
  (zeroModel, Effects.none)

update: Action -> AppModel -> (AppModel, Effects Action)
update action model =
  case action of
    ShowUsers ->
      ({model | count <- model.count + 1 }, Effects.none)
    _ ->
      (model, Effects.none)

view: Signal.Address ExtAction -> Signal.Address Action -> AppModel -> H.Html
view addressExt address model =
  H.div [] [
    H.text "Hello",
    H.text (toString model.count)
    , menu addressExt address model
  ]

menu: Signal.Address ExtAction -> Signal.Address Action -> AppModel -> H.Html
menu addressExt address model =
  H.div [] [
    H.button [ Html.Events.onClick addressExt (ChangeRoute "users.show") ] [
      H.text "Users"
    ],
    H.a [ href "#/users/1" ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1/edit" ] [
      H.text "User 1 edit"
    ]
  ]

app =
  StartApp.start {
    init = init,
    update = update,
    view = (view extMailbox.address),
    inputs = []
  }

extMailbox: Signal.Mailbox ExtAction
extMailbox = Signal.mailbox NoOp

-- PORTS
port routeChange: Signal String
port routeChange =
  Signal.map toString extMailbox.signal

main: Signal H.Html
main =
  app.html

