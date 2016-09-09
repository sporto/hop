# Matching routes

Create a parser using `Navigation.makeParser` combined with `Hop.makeResolver`.
There are serveral strategies you can use.

## Given you have some configuration

```
routes =
  oneOf [...]

hopConfig = 
  { ... }
```

## A parser that returns `(Route, Address)`

```
urlParserRouteAddress : Navigation.Parser ( MainRoute, Address )
urlParserRouteAddress =
    let
        parse path =
            path
                |> UrlParser.parse identity routes
                |> Result.withDefault NotFoundRoute

        solver =
            Hop.makeResolver configWithHash parse
    in
        Navigation.makeParser (.href >> solver)
```

This parser:

- Takes the `.href` from the `Location` record given by `Navigation`.
- Converts that to a normalised path (done inside `makeResolver`).
- Passes the normalised path to your `parse` function, which returns a matched route or `NotFoundRoute`.
- When run returns a tuple `(Route, Address)`.

## A parser that returns only the matched route

```
urlParserOnlyRoute : Navigation.Parser MainRoute
urlParserOnlyRoute =
    let
        parse path =
            path
                |> UrlParser.parse identity routes
                |> Result.withDefault NotFoundRoute

        solver =
            Hop.makeResolver configWithHash parse
    in
        Navigation.makeParser (.href >> solver >> fst)
```

This parser only returns the matched route. The `address` record is discarded. 
However you probably need the address record for doing things with the query later.

# A parser that returns the parser result + Address

```
urlParserResultAddress : Navigation.Parser (Result String MainRoute, Address)
urlParserResultAddress =
    let
        parse path =
            path
                |> UrlParser.parse identity routes

        solver =
            Hop.makeResolver configWithHash parse
    in
        Navigation.makeParser (.href >> solver)
```

This parser returns the result from `parse` e.g. `Result String MainRoute` and the address record.
