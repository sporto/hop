module State exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id)
import Dict
import Models exposing (..)


view : AppModel -> Html msg
view model =
    div []
        [ div []
            [ text "Location path: "
            , span [ id "locationPath" ] []
            ]
        , div []
            [ text "Location query: "
            , span [ id "locationQuery" ] []
            ]
        ]
