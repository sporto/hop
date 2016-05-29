module Users.View exposing (..)

import Html exposing (..)
import Hop.Types exposing (Location)
import Users.Models exposing (User, Route, Route(..))
import Users.Messages exposing (..)
import Users.List
import Users.Show
import Users.Status


type alias ViewModel =
    { location : Location
    , route : Route
    , users : List User
    }


view : ViewModel -> Html Msg
view model =
    case model.route of
        UsersRoute ->
            Users.List.view []

        UserRoute userId ->
            Users.Show.view userId

        UserStatusRoute userId ->
            Users.Status.view userId

        NotFoundRoute ->
            notFoundView model


emptyView : Html msg
emptyView =
    span [] []


notFoundView : ViewModel -> Html msg
notFoundView model =
    div []
        [ text "Not Found"
        ]
