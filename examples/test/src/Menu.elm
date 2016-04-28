module Menu (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class, href, style)
import Dict
import Models exposing (..)
import Actions exposing (..)
import Routing.Utils exposing (reverse)
import Users.Models


view : Signal.Address Action -> AppModel -> Html
view address model =
  div
    [ class "p2 white bg-black" ]
    [ div
        []
        [ menuLink address HomeRoute "btnHome" "Home"
        , text "|"
        , menuLink address AboutRoute "btnAbout" "About"
        , text "|"
        , menuLink address (UsersRoutes Users.Models.UsersRoute) "btnUsers" "Users"
        , text "|"
        , menuLink address (UsersRoutes (Users.Models.UserRoute 1)) "btnUser1" "User 1"
        , text "|"
        , menuLink address (UsersRoutes (Users.Models.UserStatusRoute 1)) "btnUserStatus1" "User Status 1"
        , text "|"
        , queryLink address (SetQuery (Dict.singleton "keyword" "elm")) "btnSetQuery" "Set query"
        ]
    ]


menuLink : Signal.Address Action -> Route -> String -> String -> Html
menuLink address route viewId label =
  let
    path =
      reverse route

    action =
      NavigateTo path
  in
    a
      [ id viewId
      , href "javascript://"
      , onClick address action
      , class "white px2"
      ]
      [ text label ]


queryLink : Signal.Address Action -> Action -> String -> String -> Html
queryLink address action viewId label =
  a
    [ id viewId
    , href "javascript://"
    , onClick address action
    ]
    [ text label ]
