# Reverser routing

Reverse routing means converting a route tag back to an url e.g.

```
UserRoute 1 --> "/users/1"
```

In the current version Hop doesn't have any helpers for reverse routing. You can do this manually:

```elm
reverse : Route -> String
reverse route =
    case route of
        HomeRoute ->
            ""

        AboutRoute ->
            "about"

        UserRoute id ->
            "users/" ++ id 

        NotFoundRoute ->
            ""
```
