# Routee: A Router for Elm SPAs

## How this works

This router uses a list of tuples to configure routes e.g. `(route, action)`. When a route is matched the router will call the action specified with the appropiate parameters.

To navigate to a different route you call `Routee.navigateTo`, this will return an effect that your application must run via ports.

This router is made to work with StartApp. At the moment only hash routes are supported i.e. `#/users/1`.

## Setup

### Import Routee

```elm
import Routee
```

### Define actions to be called when a route matches:

```elm
type Action
	= ShowUsers Routee.Payload
	| ShowUser Routee.Payload
	| ShowNotFound Routee.Payload

```

`Routee.Payload` is the payload that your action will receive when called. See about Payload below.

You need to define an action for when a route is not found e.g. `ShowNotFound`.

### Define your routes:

```elm
routes = [
		("/users", ShowUsers),
    ("/users/:id", ShowUser)
	]
```

This is a list of tuples with: (`route to match`, `action to call`). 

To define dynamic parameter use `:`, this parameters will be filled by the router e.g. `/posts/:postId/comments/:commentId`.

### Create the router

```elm
router =
	Routee.new {
		routes = routes,
		notFoundAction = ShowNotFound
	}
```

`routes` is your list of routes defined above. `notFoundAction` is the action to call when a route is not found.

`Routee.new` will give you back a `Routee.Router` record:

```elm
{
	signal,
	payload
}
```

`signal` is the signal that will carry changes when the browser location changes.

`payload` is an initial payload when the router is created.

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

Your model needs to store the routerPayload:

```elm
type alias Model {
	routerPayload: Routee.Payload
}
```

Also your model should store an attribute for the current view to display:

```elm
type alias Model {
	routerPayload: Routee.Payload,
	currentView: String
}
```

### Add update actions

Add entries to update for actions related to routing:

```elm
update action model =
	case action of
		ShowUsers payload ->
			({model | currentView = "users", routerPayload = payload}, Effects.none)
```

### Wire up your views

Your views need to decide what to show. Use the attribute `model.currentView` for this. 

Get information about the current route from `routerPayload`. e.g.

```elm
userId =
	model.routerPayload.params
		|> Dict.get "userId"
		|> Maybe.withDefault ""
```

## About `Routee.Payload`

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

### 2. Using Routee effects

__Add two actions__

```elm
type Action
	= ...
	| RouterAction Routee.Action
	| NavigateTo String
```

RouterAction is necessary so effects from the router can be run.

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
			(model, Effects.map RouterAction (Routee.navigateTo path))
```

`Routee.navigateTo` will respond with an effect that needs to be run by your application. When this effect is run the hash will change. After that your application will receive a location change signal as described before.

## Changing the query string




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

- Show initial view upon load
- Change hash without changing query
- Navigate without adding to history
- Named routes maybe (Using the given action)
- More tests
- Docs

# Changelog


