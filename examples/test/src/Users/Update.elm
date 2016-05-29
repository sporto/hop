module Users.Update exposing (..)

import Debug
import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, addQuery, setQuery)
import Hop.Types exposing (Config, Location)
import Models
import Users.Models exposing (..)
import Users.Messages exposing (Msg(..))
import Users.Routing.Utils


type alias UpdateModel =
    { users : List User
    , location : Location
    , routerConfig : Config Models.Route
    }


update : Msg -> UpdateModel -> ( UpdateModel, Cmd Msg )
update action model =
    case Debug.log "action" action of
        NavigateTo path ->
            let
                cmd =
                    makeUrl model.routerConfig path
                        |> Navigation.modifyUrl
            in
                ( model, cmd )

        Show id ->
            let
                cmd =
                    Users.Routing.Utils.reverseWithPrefix (Users.Models.UserRoute id)
                        |> makeUrl model.routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, cmd )

        ShowStatus id ->
            let
                cmd =
                    Users.Routing.Utils.reverseWithPrefix (Users.Models.UserStatusRoute id)
                        |> makeUrl model.routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, cmd )

        AddQuery query ->
            let
                cmd =
                    model.location
                        |> addQuery query
                        |> makeUrlFromLocation model.routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, cmd )

        SetQuery query ->
            let
                cmd =
                    model.location
                        |> setQuery query
                        |> makeUrlFromLocation model.routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, cmd )
