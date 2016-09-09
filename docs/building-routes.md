# Building routes

As of version 6 Hop doesn't provide matchers anymore, instead you can use [__UrlParser__](http://package.elm-lang.org/packages/evancz/url-parser).

You build your routes by using union types:

```elm
type Route
  = HomeRoute
  | UserRoute Int
  | UserStatusRoute Int
  | NotFoundRoute
```

Then you need to create matchers for these routes:

```elm
import UrlParser exposing ((</>), format, oneOf, int, s)

matchers =
  oneOf [
    UrlParser.format HomeRoute (s "")
  , UrlParser.format UserRoute (s "users" </> int)
  , UrlParser.format UserStatusRoute (s "users" </> int </> s "status")
  ]
```

These matchers will match:

- "/"
- "users/1"
- "users/1/status"
