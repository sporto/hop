module Languages.Filter (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class, href, style)
import Dict
import Languages.Models exposing (..)
import Languages.Actions exposing (..)


type alias ViewModel =
  {}


styles : Html.Attribute
styles =
  style
    [ ( "float", "left" )
    , ( "margin-left", "2rem" )
    , ( "margin-right", "2rem" )
    ]


view : Signal.Address Action -> ViewModel -> Html
view address model =
  div
    [ styles ]
    [ h2 [] [ text "Filter" ]
    , btn address "btnSetQuery" "SetQuery" (SetQuery (Dict.singleton "latests" "true"))
    , div
        []
        [ h3 [] [ text "Kind" ]
        , div
            []
            [ btn address "btnAll" "All" (AddQuery (Dict.singleton "typed" ""))
            , btn address "btnDynamic" "Dynamic" (AddQuery (Dict.singleton "typed" "dynamic"))
            , btn address "btnStatic" "Static" (AddQuery (Dict.singleton "typed" "static"))
            ]
        ]
    ]


btn : Signal.Address Action -> String -> String -> Action -> Html
btn address viewId label action =
  button
    [ id viewId, class "btn btn-primary btn-small inline-block mr1", onClick address action ]
    [ text label ]
