# Hop: A router for Elm SPAs

![alt Hope](./assets/logo.png)

## How this works

This router uses a list of tuples to configure routes e.g. `(route, action)`. When a route is matched the router will call the action specified with the appropiate parameters.

To navigate to a different route you call `Hop.navigateTo`, this will return an effect that your application must run via ports.

This router is made to work with StartApp. At the moment only hash routes are supported i.e. `#/users/1`.

## Setup

### Import Hop

```elm
import Hop
```

### Define actions to be called when a route matches:

```elm
type Action
  = HopAction Hop.Action
	| ShowUsers Hop.Payload
	| ShowUser Hop.Payload
	| ShowNotFound Hop.Payload
```

`Hop.Payload` is the payload that your action will receive when called. See about Payload below.

You need to define an action for when a route is not found e.g. `ShowNotFound`.

### Define your routes:

```elm
routes : List (String, Hop.Payload -> Action)
routes = [
		("/users", ShowUsers),
		("/users/:id", ShowUser)
	]
```

This is a list of tuples with: (`route to match`, `action to call`). 

To define dynamic parameter use `:`, this parameters will be filled by the router e.g. `/posts/:postId/comments/:commentId`.

### Create the router

```elm
router : Hop.Router Action
router =
	Hop.new {
		routes = routes,
		notFoundAction = ShowNotFound
	}
```

`routes` is your list of routes defined above. `notFoundAction` is the action to call when a route is not found.

`Hop.new` will give you back a `Hop.Router` record:

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
	url: Erl.Url
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
	| SetQuery (Dict.Dict String String)
  | ClearQuery
```

__Change update to respond to these actions__

```elm
update action model =
	case action of
		...
		SetQuery query ->
			(model, Effects.map HopAction (Hop.setQuery model.routerPayload.url query))
		ClearQuery ->
			(model, Effects.map HopAction (Hop.clearQuery model.routerPayload.url))
```

`Hop.setQuery` Takes the current `url` as the first argument and a dictionary of key, values as second argument.
`Hop.clearQuery` Takes the current `url`

__Call these actions from your views__

```elm
button [ onClick address (SetQuery (Dict.singleton "color" "red")) ] [ text "Set query" ]
```

# Example

See example app in `./example` folder. To run the example app:

- Clone this repo
- Run `elm reactor`
- Open `http://localhost:8000/example/App.elm`

# Test

```
elm reactor
```

Open `/localhost:8000/TestRunner.elm`

## Running in Docker

docker-machine ip name-of-machine

docker-compose build
docker-compose up

Open in ip:8000

# TODO:

- ! SetQuery fails when the hash is empty
- Change hash without changing query
- Navigate without adding to history
- Named routes maybe (Using the given action)
- More tests
- Docs

## Improvements

- Can router.run be sent to the startApp inputs? i.e. remove the specific port for this.

# Changelog

`1.1.1` Fixed issue where query string won't be set when no hash wash present

