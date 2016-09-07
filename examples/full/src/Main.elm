module Main exposing (..)

import Navigation
import Hop
import Hop.Types exposing (Address)
import Messages exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)
import Routing.Config
import String
import UrlParser


urlParser : Navigation.Parser ( Route, Address )
urlParser =
    let
        parser location =
            let
                _ =
                    Debug.log "path" path

                _ =
                    Debug.log "parseResult" parseResult

                address =
                    location.href
                        |> Hop.ingest Routing.Config.config

                path =
                    Hop.pathFromAddress address ++ "/"
                        |> String.dropLeft 1

                parseResult =
                    UrlParser.parse identity Routing.Config.parser path

                route =
                    Result.withDefault NotFoundRoute parseResult
            in
                ( route, address )
    in
        Navigation.makeParser parser


urlUpdate : ( Route, Address ) -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate ( route, address ) model =
    let
        _ =
            Debug.log "urlUpdate address" address
    in
        ( { model | route = route, address = address }, Cmd.none )


init : ( Route, Address ) -> ( AppModel, Cmd Msg )
init ( route, address ) =
    ( newAppModel route address, Cmd.none )


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = (always Sub.none)
        }
