module App where

import Html as H

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href)

type alias AppModel = {
}
                      
zeroModel: AppModel
zeroModel =
  {}

type Action
  = DoNothing

init: (AppModel, Effects Action)
init =
  (zeroModel, Effects.none)

update: Action -> AppModel -> (AppModel, Effects Action)
update action model =
  (model, Effects.none)

view: Signal.Address Action -> AppModel -> H.Html
view address model =
  H.div [] [
    H.text "Hello"
    , menu address model
  ]

menu: Signal.Address Action -> AppModel -> H.Html
menu address model =
  H.div [] [
    H.a [ href "#/users" ] [
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
    view = view,
    inputs = []
  }

main: Signal H.Html
main =
  app.html
     
