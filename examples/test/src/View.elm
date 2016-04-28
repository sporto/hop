module View (..) where

import Html exposing (..)
import Models exposing (..)
import Actions exposing (..)
import Menu
import Users.View


view : Signal.Address Action -> AppModel -> Html
view address model =
  div
    []
    [ Menu.view address model
    , pageView address model
    ]


pageView : Signal.Address Action -> AppModel -> Html
pageView address model =
  case model.route of
    HomeRoute ->
      div
        []
        [ h1 [] [ text "Home" ]
        ]

    AboutRoute ->
      div
        []
        [ h1 [] [ text "About" ]
        ]

    UsersRoutes usersRoute ->
      let
        viewModel =
          { users = model.users
          , route = usersRoute
          , location = model.location
          }
      in
        Users.View.view (Signal.forwardTo address UsersAction) viewModel

    NotFoundRoute ->
      notFoundView address model


notFoundView : Signal.Address Action -> AppModel -> Html
notFoundView address model =
  div
    []
    [ text "Not Found"
    ]
