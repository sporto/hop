module Example.UserEdit where

import Dict
import Html as H

import Example.Models as Models

type Action
  = Save
  | Cancel

--update

view: Signal.Address Action -> Models.User -> H.Html
view address model =
  H.div [] [
    H.text ("User Edit " ++ model.name)
  ]
