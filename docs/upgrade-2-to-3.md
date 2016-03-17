# Upgrading from 2 to 3

Hop has changed in many ways in version 3. Please review the [Getting started guide](https://github.com/sporto/hop/blob/master/docs/getting-started.md). Following is an overview of the major changes.

## Routes

Now routes can take values, instead of:

```elm
type Route
  = Home
  | Users
  | User
  | Token
```

You can have values attached:

```elm
type Route
  = Home
  | Users
  | User Int
  | Token String
```

Routes are now defined using matchers. So instead of 

```elm
routes = 
  [ ("/users/:int", User) ]
```

You do:

```elm
import Hop.Matchers exposing(match2)

userMatcher =
  match2 User "/users" int

matchers =
  [userMatcher]
```

This is so we can have stronger types e.g. `User Int`.

## Actions

Hop.signal now returns a tuple with `(Route, Location)`. Your application needs to map this to an action. e.g.

```elm

type Action
  = HopAction ()
  | ApplyRoute ( Route, Location )

taggedRouterSignal : Signal Action
taggedRouterSignal =
  Signal.map ApplyRoute router.signal
```

This is so routes (`Route`) are different type than the application actions.

## Payload

Before Hop returned a `payload` with a dictionary with matched parameters.

Now it returns the matched route with the values e.g. `User 1` and a `Location` record in the form of a tuple:

```elm
(User 1, location)
```

`location` has the information about the current path and the query:

```elm
{
  path = ["users", "1"],
  query = <Dict String String>
}
```

## Views

In your views you don't need to 'search' for the correct parameter in the payload anymore. The parameters are now in the route e.g. `User 1`.

So instead of doing:

```elm
userId =
  model.routerPayload.params
    |> Dict.get "userId"
    |> Maybe.withDefault ""
```

You simply get the id from the route:

```elm
case User userId ->
  ...
```

The query is still a dictionary. The query is now in the `location` record as shown above.

