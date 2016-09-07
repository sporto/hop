# Hop: Navigation and routing matchers for Elm SPAs

[![Build Status](https://semaphoreci.com/api/v1/sporto/hop/branches/master/badge.svg)](https://semaphoreci.com/sporto/hop)

![alt Hop](https://raw.githubusercontent.com/sporto/hop/master/assets/logo.png)

Hop is meant to be used with [the Elm Navigation package](http://package.elm-lang.org/packages/elm-lang/navigation/). 

On top of Elm Navigation Hop provides:

- Matchers for URL parsing
- Support for nested routes
- A helper for reverse routing
- Transparent support for push or hash routing
- Helpers for changing the query string
- Encode / Decode query string

## Getting Started

Please see this [example app](https://github.com/sporto/hop/blob/master/examples/basic/Main.elm). It explains how to wire everything in the comments.

## Docs

### [Building routes](https://github.com/sporto/hop/blob/master/docs/building-routes.md)
### [Navigating](https://github.com/sporto/hop/blob/master/docs/navigating.md)
### [API](http://package.elm-lang.org/packages/sporto/hop/latest/)
### [Changelog](./docs/changelog.md)
### [Testing Hop](https://github.com/sporto/hop/blob/master/docs/testing.md)

## More docs

### [Upgrade guide 4 to 5](https://github.com/sporto/hop/blob/master/docs/upgrade-4-to-5.md)
### [Upgrade guide 3 to 4](https://github.com/sporto/hop/blob/master/docs/upgrade-3-to-4.md)
### [Upgrade guide 2.1 to 3.0](https://github.com/sporto/hop/blob/master/docs/upgrade-2-to-3.md)

### [Version 5 documentation](https://github.com/sporto/hop/tree/v5)
### [Version 4 documentation](https://github.com/sporto/hop/tree/v4)
### [Version 3 documentation](https://github.com/sporto/hop/tree/v3)
### [Version 2 documentation](https://github.com/sporto/hop/tree/v2)

### Hash routing

A proper url should have the query before the hash e.g. `?keyword=Ja#/users/1`,
but when using hash routing, query parameters are appended after the hash path e.g. `#/users/1?keyword=Ja`. 
This is done for aesthetics and so the router is fully controlled by the hash fragment.

## Examples

See `examples/basic` and `examples/full` folders. To run the example apps:

- Clone this repo
- Go to example folder
- Follow the readme in that folder

## Acknowledgements

Thanks to @etaque and @Bogdanp for the inspiration to make this better.






