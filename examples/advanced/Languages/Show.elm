module Languages.Show (..) where

import Html exposing (..)
import Html.Attributes exposing (href, style, src)
import Languages.Models exposing (..)
import Languages.Actions exposing (..)


styles : Html.Attribute
styles =
  style
    [ ( "float", "left" )
    ]


view : Signal.Address Action -> Language -> Html
view address language =
  div
    [ styles ]
    [ h2 [] [ text language.name ]
    , img [ src ("images/" ++ language.image ++ ".png") ] []
    , tags address language
    ]


tags : Signal.Address Action -> Language -> Html
tags address language =
  div [] (List.map (tag address) language.tags)


tag : Signal.Address Action -> String -> Html
tag address tagName =
  span
    []
    [ text (tagName ++ ", ")
    ]
