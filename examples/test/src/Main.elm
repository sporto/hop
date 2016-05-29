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


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser .href


urlUpdate : String -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate href model =
    let
        ( route, location ) =
            matchUrl model.routerConfig href

        _ =
            Debug.log "urlUpdate location" location
    in
        ( { model | route = route, location = location }, Cmd.none )


type alias Flags =
    { hash : Bool
    , basePath : String
    }


init : Flags -> String -> ( AppModel, Cmd Msg )
init flags href =
    let
        routerConfig =
            Routing.Config.getConfig flags.basePath flags.hash

        ( route, location ) =
            matchUrl routerConfig href
    in
        ( newAppModel routerConfig route location, Cmd.none )


main : Program Flags
main =
    Navigation.programWithFlags urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = (always Sub.none)
        }
