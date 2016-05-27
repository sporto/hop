module Main exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Dict
import Task exposing (Task)
import Navigation
import Hop exposing (getUrl)
import Hop.Matchers exposing (..)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router, newLocation)

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

-- router : Router Route
-- router =
--   Hop.new routerConfig


urlParser : Navigation.Parser (String, Navigation.Location)
urlParser =
  Navigation.makeParser (\l -> ("foo", l))


-- MESSAGES


-- type Msg
--   = HopMsg ()
--   | ApplyRoute ( Route, Location )
--   | NavigateTo String
--   | SetQuery Query

type Msg
  = NoOp
  | NavigateTo String
  | SetQuery Query


-- MODEL


type alias Model =
  { location : Location
  , route : Route
  }


newModel : Model
newModel =
  { location = newLocation
  , route = MainRoute
  }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case (Debug.log "msg" msg) of
    NoOp ->
      (model, Cmd.none)

    NavigateTo path ->
      (model, Navigation.modifyUrl (getUrl routerConfig path))

    SetQuery query ->
      (model, Cmd.none)

    --   -- ( model, Cmd.map HopAction (setQuery routerConfig query model.location) )

    -- ApplyRoute ( route, location ) ->
    --   ( { model | route = route, location = location }, Cmd.none )

    -- HopAction () ->
    --   ( model, Cmd.none )


urlUpdate : (String, Navigation.Location) -> Model -> (Model, Cmd Msg)
urlUpdate (result, location) model =
  let
    _ = Debug.log "location" location
  in
     (model, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div
    []
    [ menu model
    , pageView model
    ]


menu : Model -> Html Msg
menu model =
  div
    []
    [ div
        []
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
    span
      [ class "labelQuery" ]
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


init : (String, Navigation.Location) -> ( Model, Cmd Msg )
init resultAndLoc =
  ( newModel, Cmd.none )


-- taggedRouterSignal : Signal Action
-- taggedRouterSignal =
--   Signal.map ApplyRoute router.signal


main =
  Navigation.program urlParser
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = (always Sub.none)
    }
