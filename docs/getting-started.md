# Getting Started

## Import Hop modules

```elm
import Hop
import Hop.Matchers exposing (int, str, match1, match2)
import Hop.Navigate exposing (navigateTo)
import Hop.Types exposing (Config, Router, PathMatcher, Location)
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

- `int` is a matcher that matches only integers for a string use `str`

## Create a config record

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

## Create the router

```elm
router : Router Route
router =
  Hop.new routerConfig
```

`Hop.new` will give you back a `Hop.Router` record:

```elm
{
  run,
  signal
}
```

- `signal` is the signal that will carry changes when the browser location changes. This signal has the type `(Route, Location)`.

- `run` is a task to match the initial route, this needs to be send to a port, more details later.

## Main actions

In your main application actions define an extra action:

```elm
type Action
  = ...
  | ApplyRoute ( Route, Location )
```

- `ApplyRoute` will be called when a path matches. `ApplyRoute` will be called with a tuple `(Route, Location)`.

## Map the router signal

The router signal carries `(Route, Location)`. Map this signal to an application action:

```elm
type Action
  ...
  | ApplyRoute ( Route, Location )

taggedRouterSignal : Signal Action
taggedRouterSignal =
  Signal.map ApplyRoute router.signal
```

## Add the router signal to StartApp inputs

Your start app configuration should include the router signal:

```elm
app =
  StartApp.start {
    init = init,
    update = update,
    view = view,
    inputs = [taggedRouterSignal]
  }
```

This will allow the router to send signal to your application when the location changes.

## Add fields to your model

Your model needs to store the current location and route. 

```elm
type alias Model {
  location: Location,
  route: Route
}
```

This is needed because:

- Some navigation functions in Hop need this information to rebuild the current location.
- Your views will need information about the current route.
- Your views might need information about the current query string.

See more details about `Hop.Types.Location` below.

## Add update actions

Add entries to `update` for actions related to routing:

```elm
update action model =
  case action of
    ...

    ApplyRoute ( route, location ) ->
      ( { model | route = route, location = location }, Effects.none )
```

`ApplyRoute` will be called when the browser location changes (manually or using `navigateTo`). This action has the route that matches the path and a `Location` record. Set both values on your model.

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

## Run the router

In order to match the initial route when the application is loaded you will need to create a port specifically for this.

```elm
port routeRunTask : Task () ()
port routeRunTask =
  router.run
```

## About `Hop.Types.Location`

`router.signal` has a type of `(Route, Location)`. Location is a record that has:

```elm
{
  path: List String,
  query: Hop.Types.Query
}
```

- `path` is an array of string that has the current path e.g. `["users", "1"]` for `"/users/1"`

`query` Is dictionary of String String. You can access this information in your views to show the content.

## Navigation

You have two way to navigate:

### 1. Using plain `a` tags

```elm
  a [ href "#/users/1" ] [ text "User" ]
```

- If you are using hash routing you must add the `#`.
- If you are using path routing don't use plain a tags as this will trigger a page refresh.

### 2. Using effects

This is the preferred way and works with push state.

__Add two application actions__

```elm
type Action
  = ...
  | ApplyRoute ( Route, Location )
  | HopAction ()
  | NavigateTo String
```

- `HopAction` will be used when a location change happens, this action doesn't have any significance but needs to be accounted for.

- `NavigateTo` will be used for navigating to a location.

__Call the action from your view__

```elm
button [ onClick address (NavigateTo "/users/1") ] [ text "User" ]
```

You don't need to add `#` in this case. Hop also provides reverse routing helpers so you don't need to manually write the path.

__Respond to the action in `update`__

```elm
update action model =
  case action of
    ...
    
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo routerConfig path) )

    HopAction () ->
      ( model, Effects.none )
```

`NavigateTo` sends a selected path to `Hop.Navigate.navigateTo`. `navigateTo` will return an effect that needs to be run by your application. When this effect is run the path / hash will change. 

After that your application will receive a location change signal as described before. Tag this effect with an action of your own e.g. `HopAction`.

`HopAction` will be called after the `navigateTo` effect is run. This effect doesn't return anything significant, thus `()`.

