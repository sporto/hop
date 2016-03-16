module View (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (href, style)
import Models exposing (..)
import Actions exposing (..)
import Routing exposing (..)
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
        [ menuLink address HomeRoute "Home"
        , text "|"
        , menuLink address (LanguagesRoutes Languages.Routing.LanguagesRoute) "Languages"
        , text "|"
        , menuLink address AboutRoute "About"
        ]
    ]


menuBtn : Signal.Address Action -> Action -> String -> Html
menuBtn address action label =
  button
    [ Html.Events.onClick address action ]
    [ text label
    ]


menuLink : Signal.Address Action -> Route -> String -> Html
menuLink address route label =
  let
    path =
      reverse route

    action =
      RoutingAction (NavigateTo path)
  in
    a
      [ href "//:javascript"
      , onClick address action
      ]
      [ text label ]


pageView : Signal.Address Action -> AppModel -> Html
pageView address model =
  case model.routing.route of
    HomeRoute ->
      div
        []
        [ h2 [] [ text "Home" ]
        , div [] [ text "Click on Languages to start routing" ]
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
