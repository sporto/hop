module Example.Languages.Show where

import Html as H
import Html.Events

import Example.Models as Models
import Example.Languages.Actions as Actions

view : Signal.Address Actions.Action -> Models.Language -> H.Html
view address language =
  H.div [] [
    H.h3 [] [ H.text language.name ]
  ]
