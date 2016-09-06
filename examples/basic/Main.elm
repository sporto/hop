module Main exposing (..)

{-|
You will need Navigation and Hop

```
elm package install elm-lang/navigation
elm package install sporto/hop
```
-}

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Dict
import Navigation
import UrlParser exposing ((</>))
import Hop
import Hop.Types exposing (Config, Address, Query)


-- ROUTES


{-|
Define your routes as union types
You need to provide a route for when the current URL doesn't match any known route i.e. NotFoundRoute
-}
type Route
    = AboutRoute
    | MainRoute
    | NotFoundRoute


{-|
Define route matchers
-}
routes : UrlParser.Parser (Route -> a) a
routes =
    UrlParser.oneOf
        [ UrlParser.format MainRoute (UrlParser.s "")
        , UrlParser.format AboutRoute (UrlParser.s "about")
        ]


{-|
Define your router configuration

Use `hash = True` for hash routing e.g. `#/users/1`
Use `hash = False` for push state e.g. `/users/1`

The `basePath` is only used for path routing.
This is useful if you application is not located at the root of a url e.g. `/app/v1/users/1` where `/app/v1` is the base path.

- `matchers` is your list of matchers defined above.
- `notFound` is a route that will be returned when the path doesn't match any known route.

-}
hopConfig : Config
hopConfig =
    { hash = True
    , basePath = ""
    }



-- MESSAGES


{-|
Add messages for navigation and changing the query

-}
type Msg
    = NavigateTo String
    | SetQuery Query



-- MODEL


{-|
Add route and address to your model.

- ``Hop.Address` is record TODO (not Navigation.Location)
- `Route` is your Route union type

This is needed because:

- Some navigation functions in Hop need this information to rebuild the current address.
- Your views will need information about the current route.
- Your views might need information about the current query string.

-}
type alias Model =
    { address : Address
    , route : Route
    }


{-|
Respond to navigation messages in update i.e. NavigateTo and SetQuery

-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "msg" msg) of
        NavigateTo path ->
            let
                command =
                    -- First generate the URL using your config
                    -- Then generate a command using Navigation.newUrl
                    Hop.outputFromPath hopConfig path
                        |> Navigation.newUrl
            in
                ( model, command )

        SetQuery query ->
            let
                command =
                    -- First modify the current stored address record (setting the query)
                    -- Then generate a URL using makeUrlFromLocation
                    -- Finally, create a command using Navigation.newUrl
                    model.address
                        |> Hop.setQuery query
                        |> Hop.output hopConfig
                        |> Navigation.newUrl
            in
                ( model, command )


{-|
Create a URL Parser for Navigation

Here we take `.href` from `Navigation.address` and send this to `Hop.matchUrl`.

`matchUrl` returns a tuple: (matched route, Hop address record). e.g.

    (User 1, { path = ["users", "1"], query = Dict.empty })

-}
urlParser : Navigation.Parser ( Route, Address )
urlParser =
    let
        parser location =
            let
                _ =
                    Debug.log "parseResult" parseResult

                address =
                    location.href
                        |> Hop.ingest hopConfig

                path =
                    Hop.pathFromAddress address

                parseResult =
                    UrlParser.parse identity routes path

                route =
                    Result.withDefault NotFoundRoute parseResult
            in
                ( route, address )
    in
        Navigation.makeParser parser



-- Get the .href
-- Convert that to a normalised path
-- Parse
-- Wrap in (Route, Location)


{-|
Navigation will call urlUpdate when the address changes.
This function gets the result from `urlParser`, which is a tuple with (Route, Hop.Types.Location)

Location is a record that has:

```elm
{
  path: List String,
  query: Hop.Types.Query
}
```

- `path` is an array of string that has the current path e.g. `["users", "1"]` for `"/users/1"`
- `query` Is dictionary of String String. You can access this information in your views to show the content.

Store these two things in the model. We store address because it is needed for matching a query string.

-}
urlUpdate : ( Route, Address ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, address ) model =
    ( { model | route = route, address = address }, Cmd.none )



-- VIEWS


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
                , onClick (SetQuery (Dict.singleton "keyword" "el/m"))
                ]
                [ text "Set query string" ]
            , currentQuery model
            ]
        ]


currentQuery : Model -> Html msg
currentQuery model =
    let
        query =
            toString model.address.query
    in
        span [ class "labelQuery" ]
            [ text query ]


{-|
Views can decide what to show using `model.route`.

-}
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


{-|
Your init function will receive an initial payload from Navigation, this payload is the initial matched address.
Here we store the `route` and `address` in our model.

-}
init : ( Route, Address ) -> ( Model, Cmd Msg )
init ( route, address ) =
    ( Model address route, Cmd.none )


{-|
Wire everything using Navigation.

-}
main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = (always Sub.none)
        }
