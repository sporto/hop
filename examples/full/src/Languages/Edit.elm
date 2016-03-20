module Languages.Edit (..) where

import Html exposing (..)
import Html.Events
import Html.Attributes exposing (href, style, src, value, name)
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
    , form
        []
        [ input
            [ value language.name
            , name "name"
            , Html.Events.on "input" Html.Events.targetValue (Signal.message address << Update language.id "name")
            ]
            []
        ]
    ]
