module Examples.Basic.Languages.List where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style)
import Hop
import Dict

import Examples.Basic.Models as Models
import Examples.Basic.Languages.Actions as Actions

styles : H.Attribute
styles =
  style [
    ("float", "left"),
    ("margin-right", "2rem")
  ]

hasTag :  String -> Models.Language -> Bool
hasTag tag language =
  List.any (\t -> t == tag) language.tags

filteredLanguages : List Models.Language -> Hop.Payload -> List Models.Language
filteredLanguages languages payload =
  let
    typed =
      payload.params
        |> Dict.get "typed"
        |> Maybe.withDefault ""
  in
    case typed of
      "" ->
        languages
      _ ->
        List.filter (hasTag typed) languages

view : Signal.Address Actions.Action -> List Models.Language -> Hop.Payload -> H.Html
view address languages payload =
  H.div [ styles ] [
    H.h2 [] [ H.text "Languages" ],
    H.table [] [
      H.tbody [] (tableRows address (filteredLanguages languages payload))
    ]
  ]

tableRows : Signal.Address Actions.Action -> List Models.Language -> (List H.Html)
tableRows address collection =
  List.map (rowView address) collection

rowView : Signal.Address Actions.Action -> Models.Language -> H.Html
rowView address language =
  H.tr [] [
    H.td [] [ H.text language.id ],
    H.td [] [ 
      H.text language.name
    ],
    H.td [] [
      actionBtn address (Actions.Show language.id) "Show",
      actionBtn address (Actions.Edit language.id) "Edit"
    ]
  ]

actionBtn address action label =
  H.button [
    Html.Events.onClick address action
  ] [
    H.text label
  ]

