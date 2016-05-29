module Main exposing (..)

import Html exposing (..)
import Navigation
import Hop exposing (matchUrl)
import Hop.Types exposing (Config, Router)
import Messages exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)
import Routing.Config


-- CANNOT send flags to parser????
--makeUrlParser =


urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl Routing.Config.config)


urlUpdate : ( Route, Hop.Types.Location ) -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        _ =
            Debug.log "urlUpdate location" location
    in
        ( { model | route = route, location = location }, Cmd.none )


type alias Flags =
    { hash : Bool
    , basePath : String
    }


init : Flags -> ( Route, Hop.Types.Location ) -> ( AppModel, Cmd Msg )
init flags ( route, location ) =
    let
        routerConfig =
            Routing.Config.getConfig flags.basePath flags.hash
    in
        ( newAppModel routerConfig route location, Cmd.none )


main : Program Never
main =
    Navigation.programWithFlags urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = (always Sub.none)
        }
