module Languages.View (..) where

import Html exposing (..)
import Html.Attributes exposing (href, style)
import Languages.Models exposing (LanguageId, Language)
import Languages.Actions exposing (..)
import Languages.Routing
import Languages.Filter
import Languages.List
import Languages.Show
import Languages.Edit


type alias ViewModel =
  { languages : List Language
  , routing : Languages.Routing.Model
  }


containerStyle : Html.Attribute
containerStyle =
  style
    [ ( "margin-bottom", "5rem" )
    , ( "overflow", "auto" )
    ]


view : Signal.Address Action -> ViewModel -> Html
view address model =
  div
    [ containerStyle ]
    [ Languages.Filter.view address model
    , Languages.List.view address model
    , subView address model
    ]


subView : Signal.Address Action -> ViewModel -> Html
subView address model =
  case model.routing.route of
    Languages.Routing.LanguageRoute languageId ->
      let
        maybeLanguage =
          getLanguage model.languages languageId
      in
        case maybeLanguage of
          Just language ->
            Languages.Show.view address language

          Nothing ->
            notFoundView address model

    Languages.Routing.LanguageEditRoute languageId ->
      let
        maybeLanguage =
          getLanguage model.languages languageId
      in
        case maybeLanguage of
          Just language ->
            Languages.Edit.view address language

          _ ->
            notFoundView address model

    Languages.Routing.LanguagesRoute ->
      emptyView

    Languages.Routing.NotFoundRoute ->
      notFoundView address model


emptyView : Html
emptyView =
  span [] []


notFoundView : Signal.Address Action -> ViewModel -> Html
notFoundView address model =
  div
    []
    [ text "Not Found"
    ]


getLanguage : List Language -> LanguageId -> Maybe Language
getLanguage languages id =
  languages
    |> List.filter (\lang -> lang.id == id)
    |> List.head
