# Hop: A router for Elm SPAs

![alt Hop](https://raw.githubusercontent.com/sporto/hop/master/assets/logo.png)

## How this works

- Routes are defined as union types e.g. `User Int`
- Then you define route matchers e.g. `route2 User "/users/ int`. This creates a matcher that matches "/users/1" for example.
- Then you call `Hop.navigateTo` to change the browser location, this will return an effect that your application must run via ports.
- When the browser location changes, Hop will match the route e.g. "/users/1" -> `User 1`
- Hop provides a signal that you application consumes, this signal carries the matched routes

Hop works with StartApp out of the box.

DIAGRAM

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
### [Version 2 documentation](https://github.com/sporto/hop/tree/v2)
### [Changelog](./docs/changelog.md)

# Examples

See examples app in `./Examples/`. To run the example apps:

- Clone this repo
- Go to example folder (eg examples/basic or examples/full)
- Install packages `elm package install -y`
- Run `elm reactor`
- Open `http://localhost:8000/Main.elm`

# Testing

- `cd ./src/Test`
- `elm reactor`
- Open `/localhost:8000/Main.elm`

# TODO:

- Change hash without changing query
- Navigate without adding to history
- Push state - Support routes without hashes
- Redirects e.g. "/" -> "/dashboard"

## Improvements

- In order to match the initial route we need to manually send tasks to a port. Done via `route.run`. This is one more thing for the user to do. Is this really necessary, can this be removed? e.g. Try to channel the initial match through the existing `router.signal`.

- Remove the need to pass the current url to query methods. At the moment we need to send `setQuery url dict` because Hop cannot figure out the current query by itself. [This project](https://github.com/rgrempel/elm-web-api#webapilocation) could be the solution.

## Acknowledgements

Thanks to @etaque and @Bogdanp for the inspiration needed to make this better






