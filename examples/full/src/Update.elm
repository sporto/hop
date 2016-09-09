module Update exposing (..)

import Debug
import Navigation
import Hop exposing (output, outputFromPath, setQuery)
import Hop.Types exposing (Config)
import Messages exposing (..)
import Models exposing (..)
import Routing
import Languages.Update
import Languages.Models


navigationCmd : String -> Cmd a
navigationCmd path =
    path
        |> outputFromPath Routing.config
        |> Navigation.newUrl


routerConfig : Config
routerConfig =
    Routing.config


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case Debug.log "message" message of
        LanguagesMsg subMessage ->
            let
                updateModel =
                    { languages = model.languages
                    , address = model.address
                    }

                ( updatedModel, cmd ) =
                    Languages.Update.update subMessage updateModel
            in
                ( { model | languages = updatedModel.languages }, Cmd.map LanguagesMsg cmd )

        SetQuery query ->
            let
                command =
                    model.address
                        |> setQuery query
                        |> output routerConfig
                        |> Navigation.newUrl
            in
                ( model, command )

        ShowHome ->
            let
                path =
                    Routing.reverse HomeRoute
            in
                ( model, navigationCmd path )

        ShowLanguages ->
            let
                path =
                    Routing.reverse (LanguagesRoutes Languages.Models.LanguagesRoute)
            in
                ( model, navigationCmd path )

        ShowAbout ->
            let
                path =
                    Routing.reverse AboutRoute
            in
                ( model, navigationCmd path )
