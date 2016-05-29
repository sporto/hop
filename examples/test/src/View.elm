module View exposing (..)

import Html exposing (..)
import Html.App
import Models exposing (..)
import Messages exposing (..)
import Menu
import State
import Users.View


view : AppModel -> Html Msg
view model =
    div []
        [ Menu.view model
        , pageView model
        , State.view model
        ]


pageView : AppModel -> Html Msg
pageView model =
    case model.route of
        HomeRoute ->
            div []
                [ h1 [] [ text "Home" ]
                ]

        AboutRoute ->
            div []
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
                Html.App.map UsersAction (Users.View.view viewModel)

        NotFoundRoute ->
            notFoundView model


notFoundView : AppModel -> Html msg
notFoundView model =
    div []
        [ text "Not Found"
        ]
