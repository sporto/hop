module Languages.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, style)
import Hop.Types exposing (Location)
import Languages.Models exposing (LanguageId, Language, Route, Route(..))
import Languages.Messages exposing (..)
import Languages.Filter
import Languages.List
import Languages.Show
import Languages.Edit


type alias ViewModel =
    { languages : List Language
    , location : Location
    , route : Route
    }


containerStyle : Html.Attribute a
containerStyle =
    style
        [ ( "margin-bottom", "5rem" )
        , ( "overflow", "auto" )
        ]


view : ViewModel -> Html Msg
view model =
    div [ containerStyle ]
        [ Languages.Filter.view {}
        , Languages.List.view { languages = model.languages, location = model.location }
        , subView model
        ]


subView : ViewModel -> Html Msg
subView model =
    case model.route of
        LanguageRoute languageId ->
            let
                maybeLanguage =
                    getLanguage model.languages languageId
            in
                case maybeLanguage of
                    Just language ->
                        Languages.Show.view language

                    Nothing ->
                        notFoundView model

        LanguageEditRoute languageId ->
            let
                maybeLanguage =
                    getLanguage model.languages languageId
            in
                case maybeLanguage of
                    Just language ->
                        Languages.Edit.view language

                    _ ->
                        notFoundView model

        LanguagesRoute ->
            emptyView

        NotFoundRoute ->
            notFoundView model


emptyView : Html msg
emptyView =
    span [] []


notFoundView : ViewModel -> Html msg
notFoundView model =
    div []
        [ text "Not Found"
        ]


getLanguage : List Language -> LanguageId -> Maybe Language
getLanguage languages id =
    languages
        |> List.filter (\lang -> lang.id == id)
        |> List.head
