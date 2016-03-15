# Hop: A router for Elm SPAs

![alt Hop](https://raw.githubusercontent.com/sporto/hop/master/assets/logo.png)

## How this works

This router uses a list of tuples to configure routes e.g. `(route, action)`. When a route is matched the router will call the action specified with the appropiate parameters.

To navigate to a different route you call `Hop.navigateTo`, this will return an effect that your application must run via ports.

This router is made to work with StartApp.

### Hash routing

__At the moment only hash routes are supported i.e. `#/users/1`.__

Although a proper url should have the query before the hash e.g. `?keyword=Ja#/users/1`,
in Hop query parameters are appended after the hash path e.g. `#/users/1?keyword=Ja`. 
This is done for aesthetics and so the router is fully controlled by the hash fragment.

## Docs

### Getting Started
### Building routes
### Navigating
### API
### Upgrade guide 2.1 to 3.0
### [Changelog](./docs/changelog.md)

# Examples

See examples app in `./Examples/`. To run the example apps:

- Clone this repo
- Navigate to example app (examples/basic or examples/advanced)
- Install packages `elm package install`
- Run `elm reactor`
- Open `http://localhost:8000/App.elm`

# Testing

Inside `test` folder:

```
elm reactor
```

Open `/localhost:8000/TestRunner.elm`

# TODO:

- Change hash without changing query
- Navigate without adding to history
- Support routes without hashes (Push state)

## Improvements

- In order to match the initial route we need to manually send tasks to a port. Done via `route.run`. This is one more thing for the user to do. Is this really necessary, can this be removed? e.g. Try to channel the initial match through the existing `router.signal`.

- Remove the need to pass the current url to query methods. At the moment we need to send `setQuery url dict` because Hop cannot figure out the current query by itself. [This project](https://github.com/rgrempel/elm-web-api#webapilocation) could be the solution.







