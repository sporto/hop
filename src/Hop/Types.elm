module Hop.Types (Config, Router, PathMatcher, Query, Location, newLocation, newQuery) where

{-|

# Types
@docs Config, Router, PathMatcher, Query, Location

# Create
@docs newLocation, newQuery
-}

import Dict
import Task exposing (Task)
import Combine exposing (Parser)


{-| A Dict that holds query parameters

    Dict.Dict String String
-}
type alias Query =
  Dict.Dict String String


{-| A Record that represents the current location
Includes a `path` and a `query`

    {
      path: String,
      query: Query
    }
-}
type alias Location =
  { path : List String
  , query : Query
  }


{-| A path matcher
-}
type alias PathMatcher action =
  { parser : Parser action
  , segments : List String
  }


{-| Configuration input for Hop.new

- basePath: Only for pushState routing (not hash). e.g. "/app". All routing and matching is done after this basepath.
- hash: True for hash routing, False for pushState routing.
- matchers: A List of route matchers.
- notFound: Route that will match when a location is not found.

-}
type alias Config route =
  { basePath : String
  , hash : Bool
  , matchers : List (PathMatcher route)
  , notFound : route
  }


{-| Router record created by Hop.new
-}
type alias Router route =
  { run : Task () ()
  , signal : Signal ( route, Location )
  }



---------------------------------------


{-|
Create an empty Query record
-}
newQuery : Query
newQuery =
  Dict.empty


{-|
Create a empty Location record
-}
newLocation : Location
newLocation =
  { query = newQuery
  , path = []
  }
