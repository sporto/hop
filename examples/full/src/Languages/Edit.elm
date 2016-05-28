module Languages.Edit exposing (..)

import Html exposing (..)
import Html.Events exposing (on, targetValue)
import Html.Attributes exposing (href, style, src, value, name)
import Json.Decode as Json
import Languages.Models exposing (..)
import Languages.Messages exposing (..)


styles : Html.Attribute a
styles =
    style
        [ ( "float", "left" )
        ]


view : Language -> Html Msg
view language =
    div [ styles ]
        [ h2 [] [ text language.name ]
        , form []
            [ input
                [ value language.name
                , name "name"
                , on "input" (Json.map (Update language.id "name") targetValue)
                ]
                []
            ]
        ]
