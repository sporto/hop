module Languages.List (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, href, style)
import Hop.Types exposing (Location)
import Dict
import Languages.Models exposing (..)
import Languages.Actions exposing (..)


type alias ViewModel =
  { languages : List Language
  , location : Location
  }


styles : Html.Attribute
styles =
  style
    [ ( "float", "left" )
    , ( "margin-right", "2rem" )
    ]


hasTag : String -> Language -> Bool
hasTag tag language =
  List.any (\t -> t == tag) language.tags


filteredLanguages : ViewModel -> List Language
filteredLanguages model =
  let
    typed =
      model.location.query
        |> Dict.get "typed"
        |> Maybe.withDefault ""
  in
    case typed of
      "" ->
        model.languages

      _ ->
        List.filter (hasTag typed) model.languages


view : Signal.Address Action -> ViewModel -> Html
view address model =
  div
    [ styles ]
    [ h2 [] [ text "Languages" ]
    , table
        []
        [ tbody [] (tableRows address (filteredLanguages model)) ]
    ]


tableRows : Signal.Address Action -> List Language -> List Html
tableRows address collection =
  List.map (rowView address) collection


rowView : Signal.Address Action -> Language -> Html
rowView address language =
  tr
    []
    [ td [] [ text (toString language.id) ]
    , td
        []
        [ text language.name
        ]
    , td
        []
        [ actionBtn address (Show language.id) "Show"
        , actionBtn address (Edit language.id) "Edit"
        ]
    ]


actionBtn : Signal.Address Action -> Action -> String -> Html
actionBtn address action label =
  button
    [ class "regular btn btn-small", onClick address action ]
    [ text label ]
