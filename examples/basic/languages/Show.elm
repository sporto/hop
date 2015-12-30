module Examples.Basic.Languages.Show where

import Html as H
import Html.Events
import Html.Attributes exposing (href, style, src)

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
    H.img [ src ("images/" ++ language.image ++ ".png") ] [],
    tags address language
  ]

tags : Signal.Address Actions.Action -> Models.Language -> H.Html
tags address language =
  H.div [] (List.map (tag address) language.tags)
  

tag : Signal.Address Actions.Action -> String -> H.Html
tag address tagName =
  H.span [] [
    H.text (tagName ++ ", ")
  ]
