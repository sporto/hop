module Example.Languages.Filter where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style)

import Example.Models as Models
import Example.Languages.Actions as Actions

styles : H.Attribute
styles =
  style [
    ("float", "left"),
    ("margin-left", "2rem"),
    ("margin-right", "2rem")
  ]

view : Signal.Address Actions.Action -> List Models.Language -> H.Html
view address languages =
  H.div [ styles ] [
    H.h3 [] [ H.text "Filter" ],
    H.div [] [
      
    ]
  ]
