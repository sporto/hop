module Languages.View (..) where

import Html exposing (..)
import Html.Attributes exposing (href, style)
import Hop.Types exposing (Location)
import Languages.Models exposing (LanguageId, Language, Route, Route(..))
import Languages.Actions exposing (..)
import Languages.Filter
import Languages.List
import Languages.Show
import Languages.Edit


type alias ViewModel =
  { languages : List Language
  , location : Location
  , route : Route
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
    [ Languages.Filter.view address {}
    , Languages.List.view address { languages = model.languages, location = model.location }
    , subView address model
    ]


subView : Signal.Address Action -> ViewModel -> Html
subView address model =
  case model.route of
    LanguageRoute languageId ->
      let
        maybeLanguage =
          getLanguage model.languages languageId
      in
        case maybeLanguage of
          Just language ->
            Languages.Show.view address language

          Nothing ->
            notFoundView address model

    LanguageEditRoute languageId ->
      let
        maybeLanguage =
          getLanguage model.languages languageId
      in
        case maybeLanguage of
          Just language ->
            Languages.Edit.view address language

          _ ->
            notFoundView address model

    LanguagesRoute ->
      emptyView

    NotFoundRoute ->
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
