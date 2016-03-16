# Getting Started

## Import Hop modules

```elm
import Hop
import Hop.Builder exposing (..)
import Hop.Navigation exposing (..)
import Hop.Types exposing (..)
```

## Define your routes as union types

```elm
type AppRoute
  = HomeRoute
  | UserRoute int
  | NotFoundRoute
```

## Define route matchers

This will be used to match the browser location

```elm
routeHome : RouteMatcher AppRoute
routeHome =
  route1 HomeRoute "/"

routeUser : RouteMatcher AppRoute
routeUser =
  route2 UserRoute "/users" int

routes : List (RouteMatcher AppRoute)
routes =
  [ routeHome
  , routeUser
  ]
```

## Main actions

In your main application actions define three extra actions

```elm
type Action
  = HopAction ()
  | ApplyRoute ( AppRoute, Url )
  | NavigateTo String
```

- HopAction will be called when a location change happens, this action doesn't have any significance but needs to be accounted for.
- ApplyRoute will be called when a route matches. ApplyRoute is called with a tuple `(Route, Url)`.
- NavigateTo is used for navigating to a location.


## Create the router

```elm
router : Router Action
router =
  Hop.new
    { routes = routes
    , action = ApplyRoute
    , notFound = NotFoundRoute
    }
```

- `routes` is your list of routes defined above.
- `action` is the action that will be called when a location  changes
- `notFound` is a route that will be returned when the location doesn't match any known route

`Hop.new` will give you back a `Hop.Router` record:

-------------
HERE
&&&&

```elm
{
  signal,
  payload,
  run
}
```

`signal` is the signal that will carry changes when the browser location changes.

`payload` is an initial payload when the router is created.

`run` is a task to match the initial route, this needs to be send to a port, more details later.

### Add the router signal to StartApp inputs

Your start app configuration should include the router signal:

```elm
app =
  StartApp.start {
    init = init,
    update = update,
    view = view,
    inputs = [router.signal]
  }
```

This will allow the router to send signal to your application when the location changes.

### Add fields to your model

Your model needs to store the __router payload__ and an attribute for the __current view__ to display:

```elm
type alias Model {
  routerPayload: Hop.Payload,
  currentView: String
}
```

See more details about `Hop.Payload` below.

### Add update actions

Add entries to update for actions related to routing:

```elm
update action model =
  case action of
    ShowUsers payload ->
      ({model | currentView = "users", routerPayload = payload}, Effects.none)
```

It is important that you update the router payload, this is used to store the current url and the current router parameters.

### Wire up your views

Your views need to decide what to show. Use the attribute `model.currentView` for this. E.g.

```elm
subView address model =
  case model.currentView of
    "users" ->
      usersView address model
    "user" ->
      userView address model
```

Get information about the current route from `routerPayload`. e.g.

```elm
userId =
  model.routerPayload.params
    |> Dict.get "userId"
    |> Maybe.withDefault ""
```

### Run the router

In order to match the initial route when the application is loaded you will need to create a port specifically for this.

```elm
port routeRunTask : Task () ()
port routeRunTask =
  router.run
```

## About `Hop.Payload`

Your actions are called with a `Payload` record. This record has:

```elm
{
  params: Dict.Dict String String,
  url: Hop.Url
}
```

`params` Is dictionary of String String.

When a route matches the route params will be populated in this dictionary. Query string values will also be added here.

E.g. given the route `"/users/:userId/projects/:projectId"`,
when the current url is `#/users/1/projects/2?color=red`, params will contain:

```elm
Dict {
  "userId" => "1",
  "projectId" => "2",
  "color" => "red"
}
```

## Navigation

You have two way to navigate:

### 1. Using plain `a` tags

```elm
  a [ href "#/users/1" ] [ text "User" ]
```

Note that you must add the `#` in this case.

### 2. Using effects

__Add two actions__

```elm
type Action
  = ...
  | HopAction Hop.Action
  | NavigateTo String
```

HopAction is necessary so effects from the router can be run.

__Call the action from your view__

```elm
button [ onClick address (NavigateTo "/users/1") ] [ text "User" ]
```

You don't need to add `#` in this case.

__Respond to the action in `update`__

```elm
update action model =
  case action of
    ...
    NavigateTo path ->
      (model, Effects.map HopAction (Hop.navigateTo path))
```

`Hop.navigateTo` will respond with an effect that needs to be run by your application. When this effect is run the hash will change. After that your application will receive a location change signal as described before.

## Changing the query string

__Add actions for changing the query string__

```elm
type Action
  = ...
  | AddQuery (Dict.Dict String String)
  | SetQuery (Dict.Dict String String)
  | ClearQuery
```

__Change update to respond to these actions__

```elm
update action model =
  case action of
    ...
    AddQuery query ->
      (model, Effects.map HopAction (Hop.addQuery query model.routerPayload.url))
    SetQuery query ->
      (model, Effects.map HopAction (Hop.setQuery query model.routerPayload.url))
    ClearQuery ->
      (model, Effects.map HopAction (Hop.clearQuery model.routerPayload.url))
```

__Call these actions from your views__

```elm
button [ onClick address (SetQuery (Dict.singleton "color" "red")) ] [ text "Set query" ]
```

### [`Hop.addQuery`](http://package.elm-lang.org/packages/sporto/hop/latest/Hop#addQuery)

Adds the given Dict to the existing query.

### [`Hop.setQuery`](http://package.elm-lang.org/packages/sporto/hop/latest/Hop#setQuery)

Replaces the existing query with the given Dict.

### [`Hop.removeQuery`](http://package.elm-lang.org/packages/sporto/hop/latest/Hop#removeQuery)

Removes that key / value from the query string.

### [`Hop.clearQuery`](http://package.elm-lang.org/packages/sporto/hop/latest/Hop#clearQuery)

Removes the whole query string.
