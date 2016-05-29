module Languages.Update exposing (..)

import Debug
import Navigation
import Hop exposing (makeUrl, addQuery, setQuery)
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
                path =
                    addQuery routerConfig query model.location
            in
                ( model, Navigation.modifyUrl path )

        SetQuery query ->
            let
                path =
                    setQuery routerConfig query model.location

                _ =
                    Debug.log "path" path
            in
                ( model, Navigation.modifyUrl path )


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
