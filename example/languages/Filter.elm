module Example.Languages.Filter where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style)
import Dict

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
    H.h2 [] [ H.text "Filter" ],
    H.div [] [
      H.h3 [] [ H.text "Kind" ],
      H.div [] [
        btn address "All" (Actions.SetQuery (Dict.singleton "typed" "")),
        btn address "Dynamic" (Actions.SetQuery (Dict.singleton "typed" "dynamic")),
        btn address "Static" (Actions.SetQuery (Dict.singleton "typed" "static"))
      ]
    ]
  ]

btn address label action =
  H.button [
    Html.Events.onClick address action
  ] [
    H.text label
  ]
