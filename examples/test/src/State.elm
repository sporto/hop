module State (..) where

import Html exposing (..)
import Html.Attributes exposing (id)
import Dict
import Models exposing (..)
import Actions exposing (..)
import Graphics.Element exposing (show)


view : Signal.Address Action -> AppModel -> Html
view address model =
  div
    []
    [ div
        []
        [ text "Location path: "
        , span [ id "locationPath" ] [ fromElement (show model.location.path) ]
        ]
    , div
        []
        [ text "Location query: "
        , span [ id "locationQuery" ] [ model.location.query |> Dict.toList |> show |> fromElement ]
        ]
    ]
