# Hop: A router for Elm SPAs

![alt Hop](https://raw.githubusercontent.com/sporto/hop/master/assets/logo.png)

## How this works

This router uses a list of tuples to configure routes e.g. `(route, action)`. When a route is matched the router will call the action specified with the appropiate parameters.

To navigate to a different route you call `Hop.navigateTo`, this will return an effect that your application must run via ports.

This router is made to work with StartApp. 

### Hash routing

__At the moment only hash routes are supported i.e. `#/users/1`.__

Although a proper url should have the query before the hash e.g. `?keyword=Ja#/users/1`,
in Hop query parameters are appended after the hash path e.g. `#/users/1?keyword=Ja`. 
This is done for aesthetics and so the router is fully controlled by the hash fragment.

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

# Example

See example app in `./Examples/Basic`. To run the example apps:

- Clone this repo
- Run `elm reactor`
- Open `http://localhost:8000/Examples/Basic/App.elm`

# Test

```
elm reactor
```

Open `/localhost:8000/TestRunner.elm`

# TODO:

- Change hash without changing query
- Navigate without adding to history
- Support routes without hashes
- Named routes maybe (Using the given action)
- More tests

## Improvements

- In order to match the initial route we need to manually send tasks to a port. Done via `route.run`. This is one more thing for the user to do. Is this really necessary, can this be removed? e.g. Try to channel the initial match through the existing `router.signal`.

- Remove the need to pass the current url to query methods. At the moment we need to send `setQuery url dict` because Hop cannot figure out the current query by itself. [This project](https://github.com/rgrempel/elm-web-api#webapilocation) could be the solution.

# Changelog

- `2.1.0` Expose `Query` and `Url` types
- `2.0.0` Remove dependency on `Erl`. Change order of arguments on `addQuery`, `clearQuery`, `removeQuery` and `setQuery`
- `1.2.1` Url is normalized before navigation i.e append `#/` if necessary
- `1.2.0` Added `addQuery`, changed behaviour of `setQuery`.
- `1.1.1` Fixed issue where query string won't be set when no hash wash present

