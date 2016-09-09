# Navigating

## Changing the location

Use `Hop.outputFromPath` for changing the browser location.

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

React to this message in update:

```elm
NavigateTo path ->
  let
    command =
      Hop.outputFromPath routerConfig path
        |> Navigation.newUrl
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
          model.address
            |> Hop.addQuery query
            |> Hop.output routerConfig
            |> Navigation.newUrl
      in
        (model, command)
```

You need to pass the current `address` record to these functions. 
Then you use that `address` record to generate a url using `output`.

Trigger these messages from your views:

```elm
button [ onClick (AddQuery (Dict.singleton "color" "red")) ] [ text "Set query" ]
```

See details of available functions at <http://package.elm-lang.org/packages/sporto/hop/latest/Hop>
