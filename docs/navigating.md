# Navigating

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
