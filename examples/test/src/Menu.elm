module Menu exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, href)
import Dict
import Models exposing (..)
import Messages exposing (..)
import Routing.Utils exposing (reverse)
import Users.Models


view : AppModel -> Html Msg
view model =
    div []
        [ div []
            [ menuLink HomeRoute "btnHome" "Home"
            , text "|"
            , menuLink AboutRoute "btnAbout" "About"
            , text "|"
            , menuLink (UsersRoutes Users.Models.UsersRoute) "btnUsers" "Users"
            , text "|"
            , menuLink (UsersRoutes (Users.Models.UserRoute 1)) "btnUser1" "User 1"
            , text "|"
            , menuLink (UsersRoutes (Users.Models.UserStatusRoute 1)) "btnUserStatus1" "User Status 1"
            , text "|"
            , queryLink (SetQuery (Dict.singleton "keyword" "elm")) "btnSetQuery" "Set query"
            , text "|"
            , queryLink ClearQuery "btnClearQuery" "Clear query"
            ]
        ]


menuLink : Route -> String -> String -> Html Msg
menuLink route viewId label =
    let
        path =
            reverse route

        cmd =
            NavigateTo path
    in
        a
            [ id viewId
            , href "javascript://"
            , onClick cmd
            ]
            [ text label ]


queryLink : Msg -> String -> String -> Html Msg
queryLink msg viewId label =
    a
        [ id viewId
        , href "javascript://"
        , onClick msg
        ]
        [ text label ]
