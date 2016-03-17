# Building routes

You build your routes by using union types:

```elm
type Route
  = HomeRoute
  | UserRoute Int
  | UserStatusRoute Int
  | NotFoundRoute
```

Then you need to create path matchers for these routes:

```elm
import Hop.Matchers exposing (match1, match2, int)

matcherHome : PathMatcher Route
matcherHome =
  match1 HomeRoute "/"
```

This matcher matches a route with one segment thus called `match1`.

```elm
matcherUser : PathMatcher Route
matcherUser =
  match2 UserRoute "/users" int
```

This matches a route with two segments. The first segment is always a string. The second segment can be `int` or `str` (exposed in Hop.Matchers).

For example a matcher like this:

```elm
matcher =
  match2 UserRoute "/users/" int
```

Will match "/users/1" but not "/users/abc".

```elm
matchPath [matcher] NotFoundRoute "/users/1"
--> UserRoute 1

matchPath [matcher] NotFoundRoute "/users/abc"
--> NotFoundRoute
```

To match "/users/abc" you use `str`. e.g.

```elm
type Route
  = UserRoute String

matcher =
  match2 UserRoute "/users/" str

matchPath [matcher] NotFoundRoute "/users/abc"
--> UserRoute "abc"
```

See more information about matcher in <TODO>

## Nested routes

Hop supports nested routes. Define your children routes:

```elm
type ServicesRoute
  = Service Int
  | ServiceStatus Int
```

Then define your top level routes:

```elm
type Route
  = Home
  | Company Int
  | CompanyServices Int (ServicesRoute)
  | NotFound
```

Create path matchers:

```elm
import Hop.Matchers.exposing (match2, match3, nested2, matchPath)

-- Matchers for services

serviceMatcher = 
  match2 Service "/services/" int

serviceStatusMatcher = 
  match3 ServiceStatus "/services/" int "/status"

servicesMatchers = 
  [serviceMatcher, serviceStatusMatcher]

-- Top level matchers

companyMatcher =
  match2 Company "/companies/" int

companyServicesMatcher = 
  nested2 CompanyServices "/companies" int servicesMatchers

matchers =
  [companyMatcher, companyServicesMatcher]
```

Then you can match nested paths:

```elm
matchPath matchers NotFound "/companies/1/services/2/status"
--> CompanyServices 1 (ServiceStatus 2)
```

`matchPath` is used internally in Hop. In practice the router signal will return a tuple like: `(CompanyServices 1 (ServiceStatus 2), location)`.

## Reverse routing

Reverse routing means creating a path from a route.
e.g. `User 1` -> `"/users/1"`

Hop provides `matcherToPath` to help with this. However you still need to do some pattern matching in your app.

```elm
type alias Route
  = Users
  | User Int
  | NotFound

reverse : Route -> String
reverse route =
  case route of

    Users ->
      matcherToPath usersMatcher []

    User id ->
      matcherToPath userMatcher [toString id]

    NotFound ->
      ""
```

See more details at <TODO>

