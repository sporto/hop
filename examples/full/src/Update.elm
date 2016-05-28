module Update exposing (..)

import Debug
import Navigation
import Hop exposing (makeUrl, setQuery)
import Messages exposing (..)
import Models exposing (..)
import Routing.Config
import Routing.Utils
import Languages.Update
import Languages.Models


navigationCmd : String -> Cmd a
navigationCmd path =
    Navigation.modifyUrl (makeUrl Routing.Config.config path)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case Debug.log "message" message of
        LanguagesMsg subMessage ->
            let
                updateModel =
                    { languages = model.languages
                    , location = model.location
                    }

                ( updatedModel, cmd ) =
                    Languages.Update.update subMessage updateModel
            in
                ( { model | languages = updatedModel.languages }, Cmd.map LanguagesMsg cmd )

        SetQuery query ->
            let
                path =
                    setQuery Routing.Config.config query model.location
            in
                ( model, navigationCmd path )

        ShowHome ->
            let
                path =
                    Routing.Utils.reverse HomeRoute
            in
                ( model, navigationCmd path )

        ShowLanguages ->
            let
                path =
                    Routing.Utils.reverse (LanguagesRoutes Languages.Models.LanguagesRoute)
            in
                ( model, navigationCmd path )

        ShowAbout ->
            let
                path =
                    Routing.Utils.reverse AboutRoute
            in
                ( model, navigationCmd path )
