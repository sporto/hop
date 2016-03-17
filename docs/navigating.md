# Navigating

## Changing the location

Use `Hop.Navigate.navigateTo` for changing the browser location.

Add actions for navigation"

```elm
type Action
  = ...
  | HopAction ()
  | NavigateTo String
```

In your view:

```elm
button [ onClick address (NavigateTo "/users/1") ] [ text "User" ]
```

You can create the path ("/users/1") by using reverse routing, see [here](https://github.com/sporto/hop/blob/master/docs/building-routes.md#reverse-routing). 

Then in update:

```elm
update action model =
  case action of
    ...
    
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    HopAction () ->
      ( model, Effects.none )
```

## Changing the query string

Add actions for changing the query string:

```elm
type Action
  = ...
  | HopAction ()
  | AddQuery (Dict.Dict String String)
  | SetQuery (Dict.Dict String String)
  | ClearQuery
```

Change update to respond to these actions:

```elm
import Hop.Navigate exposing(addQuery, setQuery, clearQuery)

update action model =
  case action of
    ...

    AddQuery query ->
      (model, Effects.map HopAction (addQuery query model.location))

    SetQuery query ->
      (model, Effects.map HopAction (setQuery query model.location))

    ClearQuery ->
      (model, Effects.map HopAction (clearQuery model.location))
```

You need to pass the current `location` record to these functions. Hop will use that record to generate the new path.

Call these actions from your views:

```elm
button [ onClick address (SetQuery (Dict.singleton "color" "red")) ] [ text "Set query" ]
```

See details of available functions at <TODO>
