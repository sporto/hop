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
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)


{-|
Hop.Matchers exposes functions for building route matchers
-}
import Hop.Matchers exposing (..)


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

Define matchers

For example:

    match1 AboutRoute "/about"

Will match "/about" and return AboutRoute

    match2 UserRoute "/users" int

Will match "/users/1" and return (UserRoute 1)

`int` is a matcher that matches only integers, for a string use `str` e.g.

    match2 UserRoute "/users" str

Would match "/users/abc"

-}
matchers : List (PathMatcher Route)
matchers =
    [ match1 MainRoute ""
    , match1 AboutRoute "/about"
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
routerConfig : Config Route
routerConfig =
    { hash = True
    , basePath = ""
    , matchers = matchers
    , notFound = NotFoundRoute
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
Add route and location to your model.

- `Location` is a `Hop.Types.Location` record (not Navigation.Location)
- `Route` is your Route union type

This is needed because:

- Some navigation functions in Hop need this information to rebuild the current location.
- Your views will need information about the current route.
- Your views might need information about the current query string.

-}
type alias Model =
    { location : Location
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
                    -- First generate the URL using your router config
                    -- Then generate a command using Navigation.modifyUrl
                    makeUrl routerConfig path
                        |> Navigation.modifyUrl
            in
                ( model, command )

        SetQuery query ->
            let
                command =
                    -- First modify the current stored location record (setting the query)
                    -- Then generate a URL using makeUrlFromLocation
                    -- Finally, create a command using Navigation.modifyUrl
                    model.location
                        |> setQuery query
                        |> makeUrlFromLocation routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, command )


{-|
Create a URL Parser for Navigation

Here we take `.href` from `Navigation.location` and send this to `Hop.matchUrl`.

`matchUrl` returns a tuple: (matched route, Hop location record). e.g.

    (User 1, { path = ["users", "1"], query = Dict.empty })

-}
urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl routerConfig)


{-|
Navigation will call urlUpdate when the location changes.
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

Store these two things in the model. We store location because it is needed for matching a query string.

-}
urlUpdate : ( Route, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    ( { model | route = route, location = location }, Cmd.none )



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
Your init function will receive an initial payload from Navigation, this payload is the initial matched location.
Here we store the `route` and `location` in our model.

-}
init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location ) =
    ( Model location route, Cmd.none )


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
