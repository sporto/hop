module Example.UserEdit where

import Dict
import Html as H
import Html.Events

import Example.Models as Models

type Action
  = Save
  | Show String
  | Cancel

--update

view: Signal.Address Action -> Models.User -> H.Html
view address model =
  H.div [] [
    H.text ("User Edit " ++ model.name),
    H.button [ Html.Events.onClick address (Show model.id) ] [
      H.text "Show"
    ]
  ]
