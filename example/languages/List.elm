module Example.Languages.List where

import Html as H
import Example.Models as Models
import Example.Languages.Actions as Actions

view : Signal.Address Actions.Action -> List Models.Language -> H.Html
view address languages =
  H.div [] [
    H.h3 [] [ H.text "Languages" ],
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
    H.td [] [ H.text language.name ],
    H.td [] [

    ]
  ]
