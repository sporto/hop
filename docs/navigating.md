# Navigating

## Changing the location

Use `Hop.makeUrl` for changing the browser location.

Add a message:

```elm
type Msg
  ...
  | NavigateTo String
```

Trigger this message from you view:

```elm
button [ onClick (NavigateTo "/users") ] [ text "Users" ]
```

You can create the paths (e.g. "/users/1") by using reverse routing, see [here](https://github.com/sporto/hop/blob/master/docs/building-routes.md#reverse-routing).

React to this message in update:

```elm
NavigateTo path ->
  let
    command =
      makeUrl routerConfig path
        |> Navigation.modifyUrl
  in
    ( model, command )
```

## Changing the query string

Add actions for changing the query string:

```elm
type Msg
  = ...
  | AddQuery (Dict.Dict String String)
  | SetQuery (Dict.Dict String String)
  | ClearQuery
```

Change update to respond to these actions:

```elm
import Hop exposing(addQuery, setQuery, clearQuery)

update msg model =
  case msg of
    ...

    AddQuery query ->
      let
        command =
          model.location
            |> addQuery query
            |> makeUrlFromLocation routerConfig
            |> Navigation.modifyUrl
      in
        (model, command)
```

You need to pass the current `location` record to these functions. Then you use that `location` record to generate a url using makeUrlFromLocation`.

Trigger these messages from your views:

```elm
button [ onClick (AddQuery (Dict.singleton "color" "red")) ] [ text "Set query" ]
```

See details of available functions at <http://package.elm-lang.org/packages/sporto/hop/latest/Hop>
