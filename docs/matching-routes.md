# Matching routes

Create a parser using `Navigation.makeParser` combined with `Hop.makeMatcher`.
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
urlParser : Navigation.Parser ( Route, Address )
urlParser =
    let
        parse path =
            path
                |> UrlParser.parse identity routes
                |> Result.withDefault NotFoundRoute

        matcher =
            Hop.makeMatcher hopConfig .href parse (,)
    in
        Navigation.makeParser matcher
```

This parser

- Takes the `.href` from the `Location` record given by `Navigation`
- Converts that to a normalised path (done inside `makeMatcher`)
- Passes the normalisedPath to your `parse` function, which returns a matched route or `NotFoundRoute`
- Passes the return from the `parse` function above, plus an `Address` record to a format function. In this case just `(,)` so we return a tuple with `(Route, Address)`.

## A parser that returns only the matched route

```
urlParser : Navigation.Parser MainRoute
urlParser =
    let
        parse path =
            path
                |> UrlParser.parse identity routes
                |> Result.withDefault NotFoundRoute

        format route address =
            route

        matcher =
            Hop.makeMatcher hopConfig .href parse format
    in
        Navigation.makeParser matcher
```

This parser only returns the matched route, the `Address` record is discarded. However you probably need the address record for doing things with the query later.

# A parser that returns the parser result + Address

```
urlParser : Navigation.Parser (Result String MainRoute, Address)
urlParser =
    let
        parse path =
            path
                |> UrlParser.parse identity routes

        matcher =
            Hop.makeMatcher hopConfig .href parse (,)
    in
        Navigation.makeParser matcher
```

This parser returns the result from `parse` e.g. `Result String MainRoute`
