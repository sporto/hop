# Nesting routes

UrlParser supports nested routes:

```elm
type UserRoute
    = UsersRoute
    | UserRoute UserId

type MainRoute
    = HomeRoute
    | AboutRoute
    | UsersRoutes UserRoute
    | NotFoundRoute

usersMatchers =
    [ UrlParser.map UserRoute (int)
    , UrlParser.map UsersRoute (s "")
    ]

mainMatchers =
    [ UrlParser.map HomeRoute (s "")
    , UrlParser.map AboutRoute (s "about")
    , UrlParser.map UsersRoutes (s "users" </> (oneOf usersMatchers))
    ]

matchers =
  oneOf mainMatchers 
```

With a setup like this UrlParser will be able to match routes like:

- "" -> HomeRoute
- "/about" -> AboutRoute
- "/users" -> UsersRoutes UsersRoute
- "/users/2" -> UsersRoutes (UserRoute 2)
