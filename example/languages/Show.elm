module Example.Languages.Show where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style, src)

import Example.Models as Models
import Example.Languages.Actions as Actions

styles : H.Attribute
styles =
  style [
    ("float", "left")
  ]

view : Signal.Address Actions.Action -> Models.Language -> H.Html
view address language =
  H.div [ styles ] [
    H.h3 [] [ H.text language.name ],
    H.img [ src ("images/" ++ language.image ++ ".png") ] []
  ]
