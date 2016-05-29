module Languages.Update exposing (..)

import Debug
import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, addQuery, setQuery)
import Hop.Types exposing (Config, Location)
import Routing.Config
import Models
import Languages.Models exposing (..)
import Languages.Messages exposing (Msg(..))
import Languages.Routing.Utils


type alias UpdateModel =
    { languages : List Language
    , location : Location
    }


routerConfig : Config Models.Route
routerConfig =
    Routing.Config.config


navigationCmd : String -> Cmd a
navigationCmd path =
    Navigation.modifyUrl (makeUrl Routing.Config.config path)


update : Msg -> UpdateModel -> ( UpdateModel, Cmd Msg )
update message model =
    case Debug.log "message" message of
        Show id ->
            let
                path =
                    Languages.Routing.Utils.reverseWithPrefix (Languages.Models.LanguageRoute id)
            in
                ( model, navigationCmd path )

        Edit id ->
            let
                path =
                    Languages.Routing.Utils.reverseWithPrefix (Languages.Models.LanguageEditRoute id)
            in
                ( model, navigationCmd path )

        Update id prop value ->
            let
                udpatedLanguages =
                    List.map (updateWithId id prop value) model.languages
            in
                ( { model | languages = udpatedLanguages }, Cmd.none )

        AddQuery query ->
            let
                command =
                    model.location
                        |> addQuery query
                        |> makeUrlFromLocation routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, command )

        SetQuery query ->
            let
                command =
                    model.location
                        |> setQuery query
                        |> makeUrlFromLocation routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, command )


updateWithId : LanguageId -> String -> String -> Language -> Language
updateWithId id prop value language =
    if id == language.id then
        case prop of
            "name" ->
                { language | name = value }

            _ ->
                language
    else
        language
