module Main exposing (..)

import Navigation
import Hop exposing (matchUrl)
import Hop.Types exposing (Router)
import Messages exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)
import Routing.Config


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


init : ( Route, Hop.Types.Location ) -> ( AppModel, Cmd Msg )
init ( route, location ) =
    ( newAppModel route location, Cmd.none )


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = (always Sub.none)
        }
