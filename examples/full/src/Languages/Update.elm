module Languages.Update exposing (..)

import Debug
import Navigation
import Hop exposing (output, outputFromPath, addQuery, setQuery)
import Hop.Types exposing (Config, Address)
import Routing.Config
import Languages.Models exposing (..)
import Languages.Messages exposing (Msg(..))
import Languages.Routing.Utils


type alias UpdateModel =
    { languages : List Language
    , address : Address
    }


routerConfig : Config
routerConfig =
    Routing.Config.config


navigationCmd : String -> Cmd a
navigationCmd path =
    path
        |> outputFromPath routerConfig
        |> Navigation.modifyUrl


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
                    model.address
                        |> addQuery query
                        |> output routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, command )

        SetQuery query ->
            let
                command =
                    model.address
                        |> setQuery query
                        |> output routerConfig
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
