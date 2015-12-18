module Example.Languages.List where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style)

import Example.Models as Models
import Example.Languages.Actions as Actions

styles : H.Attribute
styles =
  style [
    ("float", "left"),
    ("margin-right", "2rem")
  ]

view : Signal.Address Actions.Action -> List Models.Language -> H.Html
view address languages =
  H.div [ styles ] [
    H.h2 [] [ H.text "Languages" ],
    H.table [] [
      H.tbody [] (tableRow address languages)
    ]
  ]

tableRow: Signal.Address Actions.Action -> List Models.Language -> (List H.Html)
tableRow address collection =
  List.map (rowView address) collection

rowView: Signal.Address Actions.Action -> Models.Language -> H.Html
rowView address language =
  H.tr [] [
    H.td [] [ H.text language.id ],
    H.td [] [ 
      H.text language.name
    ],
    H.td [] [
      H.button [
        Html.Events.onClick address (Actions.Show language.id)
      ] [
        H.text "View"
      ]
    ]
  ]
