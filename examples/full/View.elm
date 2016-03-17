module View (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (href, style)
import Models exposing (..)
import Actions exposing (..)
import Routing
import Languages.View
import Languages.Routing


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
        [ menuLink address Routing.HomeRoute "Home"
        , text "|"
        , menuLink address (Routing.LanguagesRoutes Languages.Routing.LanguagesRoute) "Languages"
        , text "|"
        , menuLink address Routing.AboutRoute "About"
        ]
    ]


menuBtn : Signal.Address Action -> Action -> String -> Html
menuBtn address action label =
  button
    [ Html.Events.onClick address action ]
    [ text label
    ]


menuLink : Signal.Address Action -> Routing.Route -> String -> Html
menuLink address route label =
  let
    path =
      Routing.reverse route

    action =
      RoutingAction (Routing.NavigateTo path)
  in
    a
      [ href "//:javascript"
      , onClick address action
      ]
      [ text label ]


pageView : Signal.Address Action -> AppModel -> Html
pageView address model =
  case model.routing.route of
    Routing.HomeRoute ->
      div
        []
        [ h2 [] [ text "Home" ]
        , div [] [ text "Click on Languages to start routing" ]
        ]

    Routing.AboutRoute ->
      div
        []
        [ h2 [] [ text "About" ]
        ]

    Routing.LanguagesRoutes languagesRoute ->
      let
        viewModel =
          { languages = model.languages
          , routing = model.routing.languagesRouting
          }
      in
        Languages.View.view (Signal.forwardTo address LanguagesAction) viewModel

    Routing.NotFoundRoute ->
      notFoundView address model


notFoundView : Signal.Address Action -> AppModel -> Html
notFoundView address model =
  div
    []
    [ text "Not Found"
    ]
