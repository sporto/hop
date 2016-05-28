module Languages.List exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, href, style)
import Hop.Types exposing (Location)
import Dict
import Languages.Models exposing (..)
import Languages.Messages exposing (..)


type alias ViewModel =
    { languages : List Language
    , location : Location
    }


styles : Html.Attribute a
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


view : ViewModel -> Html Msg
view model =
    div [ styles ]
        [ h2 [] [ text "Languages" ]
        , table []
            [ tbody [] (tableRows (filteredLanguages model)) ]
        ]


tableRows : List Language -> List (Html Msg)
tableRows collection =
    List.map rowView collection


rowView : Language -> Html Msg
rowView language =
    tr []
        [ td [] [ text (toString language.id) ]
        , td []
            [ text language.name
            ]
        , td []
            [ actionBtn (Show language.id) "Show"
            , actionBtn (Edit language.id) "Edit"
            ]
        ]


actionBtn : Msg -> String -> Html Msg
actionBtn action label =
    button [ class "regular btn btn-small", onClick action ]
        [ text label ]
