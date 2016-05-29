# Getting Started

## Packages

You will need Navigation and Hop

```
elm package install elm-lang/navigation
elm package install sporto/hop
```

## Import modules

```elm
import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Matchers exposing (..)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)

```

## Define your routes as union types

```elm
type Route
  = HomeRoute
  | UserRoute Int
  | NotFoundRoute
```

## Define path matchers

This will be used to match the browser location

```elm
matcherHome : PathMatcher Route
matcherHome =
  match1 HomeRoute "/"

matcherUser : PathMatcher Route
matcherUser =
  match2 UserRoute "/users" int

matchers : List (PathMatcher Route)
matchers =
  [ matcherHome
  , matcherUser
  ]
```

- `int` is a matcher that matches only integers, for a string use `str`

## Create a Hop config record

```elm
routerConfig : Config Route
routerConfig =
  { hash = True
  , basePath = ""
  , matchers = matchers
  , notFound = NotFoundRoute
  }
```

Use `hash = True` for hash routing e.g. `#/users/1`
Use `hash = False` for push state e.g. `/users/1`

The `basePath` is only used for path routing. This is useful if you application is not located at the root of a url e.g. `/app/v1/users/1` where `/app/v1` is the base path.

- `matchers` is your list of matchers defined above.
- `notFound` is a route that will be returned when the path doesn't match any known route.

## Add route and location to your model

Your model needs to store the current location and route. 

```elm
type alias Model =
    { location : Location
    , route : Route
    }
```

- `Location` is a `Hop.Types.Location` record (not Navigation.Location)
- `Route` is your Route union type

This is needed because:

- Some navigation functions in Hop need this information to rebuild the current location.
- Your views will need information about the current route.
- Your views might need information about the current query string.

## Create a URL Parser for Navigation

```elm
urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl routerConfig)
```

Here we have a parser that take `.href` from `Navigation.location`. Then it send this `.href` to `Hop.matchUrl`.

`matchUrl` returns a tuple: (matched route, Hop location record).

## Create a URL update handler

```elm
urlUpdate : ( Route, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
   ( { model | route = route, location = location }, Cmd.none )
```

`Navigation` will call this function when the browser location changes. Here we simply store the current `route` and `location`.

It is important that you update the `location`, this is needed for matching a query string.

## Wire up your views

Your views need to decide what to show. Use the attribute `model.route` for this. E.g.

```elm
view address model =
  case model.route of
    HomeRoute ->
      homeView address model
    UserRoute id ->
      userView address model id
    ...
```

## Create an init function

Your init function will receive an initial payload from Navigation, this payload is the initial matched location.

```
init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location ) =
    ( Model location route, Cmd.none )
```

Here we store the `route` and `location` in our model.

## Wire everything using Navigation

```elm
main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = (always Sub.none)
        }
```

## About `Hop.Types.Location`

`matchUrl` gives you back `(Route, Location)`. Location is a record that has:

```elm
{
  path: List String,
  query: Hop.Types.Query
}
```

- `path` is an array of string that has the current path e.g. `["users", "1"]` for `"/users/1"`

`query` Is dictionary of String String. You can access this information in your views to show the content.

---

See `examples/basic/Main.elm` for a heavily commented working version.
