module MyStartApp where

import Effects exposing (Effects, Never)
import Html as H
import Signal

type Action
  = NoOp

type alias Model = {}

model0: Model
model0 = 
  {}

init: (Model, Effects Action)
init =
  (model0, Effects.none)

view: Signal.Address Action -> Model -> H.Html
view address model =
  H.div [] []

update: Action -> Model -> (Model, Effects Action)
update action model =
  (model, Effects.none)

app =
  start {
    init = init,
    update = update,
    view = view,
    init = init
  }

start definition =
  let
    mb = 
      Signal.mailbox NoOp
    (model, xf) = 
      definition.init
  in {
    html = Signal.foldp (definition.view mb.address model)
  }

main: Signal H.Html
main =
  app.html

