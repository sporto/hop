module Examples.Basic.Languages.Edit where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style, src, value, name)

import Examples.Basic.Models as Models
import Examples.Basic.Languages.Actions as Actions

styles : H.Attribute
styles =
  style [
    ("float", "left")
  ]

view : Signal.Address Actions.Action -> Models.Language -> H.Html
view address language =
  H.div [ styles ] [
    H.h2 [] [ H.text language.name ],
    H.form [] [
      H.input [
        value language.name,
        name "name",
        Html.Events.on "input" Html.Events.targetValue (Signal.message address << Actions.Update language.id "name")
      ] []
    ]
  ]
