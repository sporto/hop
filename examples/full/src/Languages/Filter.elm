module Languages.Filter exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class, href, style)
import Dict
import Languages.Messages exposing (..)


type alias ViewModel =
    {}


styles : Html.Attribute a
styles =
    style
        [ ( "float", "left" )
        , ( "margin-left", "2rem" )
        , ( "margin-right", "2rem" )
        ]


view : ViewModel -> Html Msg
view model =
    div [ styles ]
        [ h2 [] [ text "Filter" ]
        , btn "btnSetQuery" "SetQuery" (SetQuery (Dict.singleton "latests" "true"))
        , div []
            [ h3 [] [ text "Kind" ]
            , div []
                [ btn "btnAll" "All" (AddQuery (Dict.singleton "typed" ""))
                , btn "btnDynamic" "Dynamic" (AddQuery (Dict.singleton "typed" "dynamic"))
                , btn "btnStatic" "Static" (AddQuery (Dict.singleton "typed" "static"))
                ]
            ]
        ]


btn : String -> String -> Msg -> Html Msg
btn viewId label action =
    button [ id viewId, class "btn btn-primary btn-small inline-block mr1", onClick action ]
        [ text label ]
