module Update exposing (..)

import Debug
import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, setQuery, clearQuery)
import Messages exposing (..)
import Models exposing (..)
import Users.Update


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update action model =
    case Debug.log "action" action of
        UsersAction subAction ->
            let
                updateModel =
                    { users = model.users
                    , location = model.location
                    , routerConfig = model.routerConfig
                    }

                ( updatedModel, fx ) =
                    Users.Update.update subAction updateModel
            in
                ( { model | users = updatedModel.users }, Cmd.map UsersAction fx )

        NavigateTo path ->
            let
                cmd =
                    path
                        |> makeUrl model.routerConfig
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

        ClearQuery ->
            let
                cmd =
                    model.location
                        |> clearQuery
                        |> makeUrlFromLocation model.routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, cmd )
