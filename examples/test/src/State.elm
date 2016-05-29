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
            , span [ id "locationPath" ] [ text (model.location.path |> toString) ]
            ]
        , div []
            [ text "Location query: "
            , span [ id "locationQuery" ] [ text (model.location.query |> Dict.toList |> toString) ]
            ]
        ]
