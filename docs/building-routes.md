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

## Order matters

The order of the matchers makes a big difference. See these examples.

Given you have some routes and matchers:

```elm
import UrlParser exposing (format, s, parse, int, oneOf, (</>))

type Route  = UserRoute Int | UserEditRoute Int

-- match 'users/1'
userMatcher = format UserRoute (s "users" </> int)

-- match '/uses/1/edit'
userEditMatcher = format UserEditRoute (s "users" </> int </> s "edit")
```

### Incorrect order

```elm
matchers = 
    oneOf [userMatcher, userEditMatcher]

parse identity matchers "users/1"
== Ok (UserRoute 1) : Result.Result String Repl.Route

parse identity matchers "users/1/edit"
== Err "The parser worked, but /edit was left over."
```

The `userEditMatcher` doesn't even run in this case. The `userMatcher` fails and stops the flow.

## Correct order

```elm
matchers = 
    oneOf [userEditMatcher, userMatcher]

parse identity matchers "users/1"
== Ok (UserRoute 1) : Result.Result String Repl.Route

parse identity matchers "users/1/edit"
== Ok (UserEditRoute 1) : Result.Result String Repl.Route
```

This works as expected, so is important to put the more specific matchers first.
