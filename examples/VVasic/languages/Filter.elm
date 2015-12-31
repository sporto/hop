module Examples.Basic.Languages.Filter where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style)
import Dict
import Hop

import Examples.Basic.Models as Models
import Examples.Basic.Languages.Actions as Actions

styles : H.Attribute
styles =
  style [
    ("float", "left"),
    ("margin-left", "2rem"),
    ("margin-right", "2rem")
  ]

view : Signal.Address Actions.Action -> List Models.Language -> Hop.Payload -> H.Html
view address languages payload =
  H.div [ styles ] [
    H.h2 [] [ H.text "Filter" ],
    btn address "SetQuery" (Actions.SetQuery (Dict.singleton "latests" "true")),
    H.div [] [
      H.h3 [] [ H.text "Kind" ],
      H.div [] [
        btn address "All" (Actions.AddQuery (Dict.singleton "typed" "")),
        btn address "Dynamic" (Actions.AddQuery (Dict.singleton "typed" "dynamic")),
        btn address "Static" (Actions.AddQuery (Dict.singleton "typed" "static"))
      ]
    ]
  ]

btn address label action =
  H.button [
    Html.Events.onClick address action
  ] [
    H.text label
  ]
