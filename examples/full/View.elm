module View (..) where

import Html exposing (..)
import Html.Events
import Html.Attributes exposing (href, style)
import Models exposing (..)
import Actions exposing (..)
import Routing
import Languages.Models exposing (LanguageId, Language)
import Languages.Filter
import Languages.List
import Languages.Show
import Languages.Edit


-- TODO use reverse routing


containerStyle : Html.Attribute
containerStyle =
  style
    [ ( "margin-bottom", "5rem" )
    , ( "overflow", "auto" )
    ]


view : Signal.Address Action -> AppModel -> Html
view address model =
  div
    []
    [ menu address model
    , pageView address model
    ]


menu : Signal.Address Action -> AppModel -> Html
menu address model =
  div
    []
    [ div
        []
        [ menuLink "#/" "Languages"
        , text "|"
        , menuLink "#/about" "About"
        ]
    ]


menuBtn : Signal.Address Action -> Action -> String -> Html
menuBtn address action label =
  button
    [ Html.Events.onClick address action ]
    [ text label
    ]


menuLink : String -> String -> Html
menuLink path label =
  a
    [ href path ]
    [ text label
    ]


pageView : Signal.Address Action -> AppModel -> Html
pageView address model =
  case model.routing.view of
    Routing.About ->
      div
        []
        [ h2 [] [ text "About" ]
        ]

    _ ->
      let
        viewModel =
          { languages = model.languages
          , url = model.routing.url
          }
      in
        div
          [ containerStyle ]
          [ Languages.Filter.view (Signal.forwardTo address LanguagesAction) viewModel
          , Languages.List.view (Signal.forwardTo address LanguagesAction) viewModel
          , subView address model
          ]


subView : Signal.Address Action -> AppModel -> Html
subView address model =
  case model.routing.view of
    Routing.Language languageId ->
      let
        maybeLanguage =
          getLanguage model.languages languageId
      in
        case maybeLanguage of
          Just language ->
            Languages.Show.view (Signal.forwardTo address LanguagesAction) language

          Nothing ->
            emptyView

    Routing.LanguageEdit languageId ->
      let
        maybeLanguage =
          getLanguage model.languages languageId
      in
        case maybeLanguage of
          Just language ->
            Languages.Edit.view (Signal.forwardTo address LanguagesAction) language

          _ ->
            emptyView

    Routing.NotFound ->
      notFoundView address model

    _ ->
      emptyView


emptyView : Html
emptyView =
  div [] []


getLanguage : List Language -> LanguageId -> Maybe Language
getLanguage languages id =
  languages
    |> List.filter (\lang -> lang.id == id)
    |> List.head


notFoundView : Signal.Address Action -> AppModel -> Html
notFoundView address model =
  div
    []
    [ text "Not Found"
    ]
