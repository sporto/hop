module Main exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Dict
import Task exposing (Task)
import Navigation
import Hop exposing (makeUrl, matchUrl, setQuery)
import Hop.Matchers exposing (..)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)


-- ROUTES


type Route
    = AboutRoute
    | MainRoute
    | NotFoundRoute


matchers : List (PathMatcher Route)
matchers =
    [ match1 MainRoute ""
    , match1 AboutRoute "/about"
    ]


routerConfig : Config Route
routerConfig =
    { hash = True
    , basePath = ""
    , matchers = matchers
    , notFound = NotFoundRoute
    }


urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl routerConfig)



-- MESSAGES


type Msg
    = NoOp
    | NavigateTo String
    | SetQuery Query



-- MODEL


type alias Model =
    { location : Location
    , route : Route
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "msg" msg) of
        NoOp ->
            ( model, Cmd.none )

        NavigateTo path ->
            ( model, Navigation.modifyUrl (makeUrl routerConfig path) )

        SetQuery query ->
            ( model, Navigation.modifyUrl (setQuery routerConfig query model.location) )


urlUpdate : ( Route, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        _ =
            Debug.log "location" location
    in
        ( { model | route = route, location = location }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ menu model
        , pageView model
        ]


menu : Model -> Html Msg
menu model =
    div []
        [ div []
            [ button
                [ class "btnMain"
                , onClick (NavigateTo "")
                ]
                [ text "Main" ]
            , button
                [ class "btnAbout"
                , onClick (NavigateTo "about")
                ]
                [ text "About" ]
            , button
                [ class "btnQuery"
                , onClick (SetQuery (Dict.singleton "keyword" "elm"))
                ]
                [ text "Set query string" ]
            , currentQuery model
            ]
        ]


currentQuery : Model -> Html msg
currentQuery model =
    let
        query =
            toString model.location.query
    in
        span [ class "labelQuery" ]
            [ text query ]


pageView : Model -> Html msg
pageView model =
    case model.route of
        MainRoute ->
            div [] [ h2 [ class "title" ] [ text "Main" ] ]

        AboutRoute ->
            div [] [ h2 [ class "title" ] [ text "About" ] ]

        NotFoundRoute ->
            div [] [ h2 [ class "title" ] [ text "Not found" ] ]



-- APP


init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location ) =
    ( Model location route, Cmd.none )


main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = (always Sub.none)
        }
