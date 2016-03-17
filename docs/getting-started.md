# Getting Started

## Import Hop modules

```elm
import Hop
import Hop.Matchers exposing (match1, match2)
import Hop.Navigate exposing (navigateTo)
import Hop.Types exposing (Router, PathMatcher, Location)
```

## Define your routes as union types

```elm
type Route
  = HomeRoute
  | UserRoute int
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

For example given a path like "/users/1" then

```elm
matchPath matchers NotFoundRoute "/users/1"
```

Will return `UserRoute 1`. If no match is found this will return `NotFoundRoute`.

## Main actions

In your main application actions define three extra actions

```elm
type Action
  = ...
  | ApplyRoute ( Route, Location )
```

- `ApplyRoute` will be called when a path matches. `ApplyRoute` will be called with a tuple `(Route, Location)`.

## Create the router

```elm
router : Router Route
router =
  Hop.new
    { matchers = matchers
    , notFound = NotFoundRoute
    }
```

- `matchers` is your list of matchers defined above.
- `notFound` is a route that will be returned when the path doesn't match any known route.

`Hop.new` will give you back a `Hop.Router` record:

```elm
{
  run,
  signal
}
```

- `signal` is the signal that will carry changes when the browser location changes. This signal has the type `(Route, Location)`.

- `run` is a task to match the initial route, this needs to be send to a port, more details later.

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

- `ApplyRoute` will be called when the browser location changes (manually or using `navigateTo`). This action has the route that matches the path and a `Location` record. Set both values on your model.

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

Note that you must add the `#` in this case.

### 2. Using effects

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
      ( model, Effects.map HopAction (navigateTo path) )

    HopAction () ->
      ( model, Effects.none )
```

`NavigateTo` sends a selected path to `Hop.Navigate.navigateTo`. `navigateTo` will return an effect that needs to be run by your application. When this effect is run the hash will change. 

After that your application will receive a location change signal as described before. Tag this effect with an action of your own e.g. `HopAction`.

`HopAction` will be called after the `navigateTo` effect is run. This effect doesn't return anything significant, thus `()`.

