module Languages.Filter (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (href, style)
import Dict
import Languages.Models exposing (..)
import Languages.Actions exposing (..)
import Languages.Routing


styles : Html.Attribute
styles =
  style
    [ ( "float", "left" )
    , ( "margin-left", "2rem" )
    , ( "margin-right", "2rem" )
    ]


type alias ViewModel =
  { languages : List Language
  , routing : Languages.Routing.Model
  }


view : Signal.Address Action -> ViewModel -> Html
view address model =
  div
    [ styles ]
    [ h2 [] [ text "Filter" ]
    , btn address "SetQuery" (SetQuery (Dict.singleton "latests" "true"))
    , div
        []
        [ h3 [] [ text "Kind" ]
        , div
            []
            [ btn address "All" (AddQuery (Dict.singleton "typed" ""))
            , btn address "Dynamic" (AddQuery (Dict.singleton "typed" "dynamic"))
            , btn address "Static" (AddQuery (Dict.singleton "typed" "static"))
            ]
        ]
    ]


btn : Signal.Address Action -> String -> Action -> Html
btn address label action =
  button
    [ onClick address action ]
    [ text label ]
