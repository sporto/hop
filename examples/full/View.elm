module View (..) where

import Html exposing (..)
import Html.Events
import Html.Attributes exposing (href, style)
import Models exposing (..)
import Actions exposing (..)
import Routing exposing (..)
import Languages.View


-- TODO use reverse routing


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
        [ menuLink "#/" "Home"
        , text "|"
        , menuLink "#/languages" "Languages"
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
  case model.routing.route of
    HomeRoute ->
      div
        []
        [ h2 [] [ text "Home" ]
        ]

    AboutRoute ->
      div
        []
        [ h2 [] [ text "About" ]
        ]

    LanguagesRoutes languagesRoute ->
      let
        viewModel =
          { languages = model.languages
          , routing = model.routing.languagesRouting
          }
      in
        Languages.View.view (Signal.forwardTo address LanguagesAction) viewModel

    NotFoundRoute ->
      notFoundView address model


notFoundView : Signal.Address Action -> AppModel -> Html
notFoundView address model =
  div
    []
    [ text "Not Found"
    ]
