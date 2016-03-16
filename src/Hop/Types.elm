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


{-| A matcher for a path
-}
type alias PathMatcher action =
  { parser : Parser action
  , segments : List String
  }


{-| Configuration input for Hop.new
-}
type alias Config actionTag routeTag =
  { action : ( routeTag, Location ) -> actionTag
  , notFound : routeTag
  , matchers : List (PathMatcher routeTag)
  }


{-| Router record created by Hop.new
-}
type alias Router actionTag =
  { signal : Signal actionTag
  , run : Task () ()
  }


{-|
Create a new Query record
-}
newQuery : Query
newQuery =
  Dict.empty


{-|
Create a new Location record
-}
newLocation : Location
newLocation =
  { query = newQuery
  , path = []
  }
