# Hop: A router for Elm SPAs

[ ![Codeship Status for sporto/hop](https://codeship.com/projects/dd1caad0-cea9-0133-1fa5-5ed74b30bb55/status?branch=master)](https://codeship.com/projects/141023)

![alt Hop](https://raw.githubusercontent.com/sporto/hop/master/assets/logo.png)

## How this works

### Matching routes

     ,-------.            ,---.                ,---.
     |History|            |Hop|                |App|
     `---+---'            `-+-'                `-+-'
         |1 location change |                    |  
         |----------------->|                    |  
         |                  |                    |  
         |                  |2 (Route, Location) |  
         |                  |------------------->|  
     ,---+---.            ,-+-.                ,-+-.
     |History|            |Hop|                |App|
     `-------'            `---'                `---'


- Routes are defined as union types e.g. `User Int`
- You define path matchers e.g. `match2 User "/users/ int`. This matches a path like `/users/1`.
- (1) When the browser location changes, Hop will match the path e.g. `/users/1` -> `User 1`.
- (2) Hop provides a signal that you application consumes, this signal carries the matched routes and information about the current location.

### Navigation

     ,---.          ,---.              ,---.          ,-------.
     |Elm|          |App|              |Hop|          |History|
     `-+-'          `-+-'              `-+-'          `---+---'
       |              |1 navigateTo path |                |    
       |              |----------------->|                |    
       |              |                  |                |    
       |              |                  | 2 change path  |    
       |              |                  |--------------->|    
       |              |                  |                |    
       |              |                  |   3 Task       |    
       |              |                  |<- - - - - - - -|    
       |              |                  |                |    
       |              |    4 Effects     |                |    
       |              |<- - - - - - - - -|                |    
       |              |                  |                |    
       |   5 Task     |                  |                |    
       |<-------------|                  |                |    
     ,-+-.          ,-+-.              ,-+-.          ,---+---.
     |Elm|          |App|              |Hop|          |History|
     `---'          `---'              `---'          `-------'


- (1-2) To change the browser location you call `Hop.Navigate.navigateTo`.
- (3-5) This will return an effect that your application must run via ports.
- When the task is run by Elm the browser location changes.

Hop works with StartApp out of the box.

### Hash routing

__At the moment only hash routes are supported i.e. `#/users/1`.__

Although a proper url should have the query before the hash e.g. `?keyword=Ja#/users/1`,
in Hop query parameters are appended after the hash path e.g. `#/users/1?keyword=Ja`. 
This is done for aesthetics and so the router is fully controlled by the hash fragment.

## Docs

### [Getting Started](https://github.com/sporto/hop/blob/master/docs/getting-started.md)
### [Building routes](https://github.com/sporto/hop/blob/master/docs/building-routes.md)
### [Navigating](https://github.com/sporto/hop/blob/master/docs/navigating.md)
### API
### [Upgrade guide 2.1 to 3.0](https://github.com/sporto/hop/blob/master/docs/upgrade-2-to-3.md)
### [Version 2 documentation](https://github.com/sporto/hop/tree/v2)
### [Changelog](./docs/changelog.md)

## Examples

See [examples](https://github.com/sporto/hop/tree/master/examples). To run the example apps:

- Clone this repo
- Go to example folder (e.g. `examples/basic` or `examples/full`)
- Install packages `elm package install -y`
- Run `elm reactor`
- Open `http://localhost:8000/Main.elm`

## Testing

- `cd ./src/Test`
- `elm reactor`
- Open `/localhost:8000/Main.elm`

## TODO:

- Change hash without changing query
- Navigate without adding to history
- Push state - Support routes without hashes
- Redirects e.g. "/" -> "/dashboard"

## Possible improvements

- In order to match the initial route we need to manually send tasks to a port. Done via `route.run`. This is one more thing for the user to do. Is this really necessary, can this be removed? Maybe in Elm 0.17.

- Remove the need to pass the current url to query methods. At the moment we need to send `setQuery location dict` because Hop cannot figure out the current query by itself. [This project](https://github.com/rgrempel/elm-web-api#webapilocation) could be the solution.

## Acknowledgements

Thanks to @etaque and @Bogdanp for the inspiration to make this better.






