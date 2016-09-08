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
    [ UrlParser.format UserRoute (int)
    , UrlParser.format UsersRoute (s "")
    ]

mainMatchers =
    [ UrlParser.format HomeRoute (s "")
    , UrlParser.format AboutRoute (s "about")
    , UrlParser.format UsersRoutes (s "users" </> (oneOf usersMatchers))
    ]

matchers =
  oneOf mainMatchers 
```

With a setup like this UrlParser will be able to match routes like:

- "" -> HomeRoute
- "/about" -> AboutRoute
- "/users" -> UsersRoutes UsersRoute
- "/users/2" -> UsersRoutes (UserRoute 2)
