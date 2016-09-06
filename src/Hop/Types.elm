module Hop.Types exposing (Config, Query, Address)

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Types
@docs Config, Address, Query

-}

import Dict

{-| A Dict that holds query parameters

    Dict.Dict String String
-}
type alias Query =
    Dict.Dict String String

{-| A Record that represents the current location
Includes a `path` and a `query`

    {
      path: List String,
      query: Query
    }
-}
type alias Address =
    { path : List String
    , query : Query
    }

{-| Hop Configuration

- basePath: Only for pushState routing (not hash). e.g. "/app". All routing and matching is done after this basepath.
- hash: True for hash routing, False for pushState routing.
- notFound: Route that will match when a location is not found.

-}
type alias Config =
    { basePath : String
    , hash : Bool
    }

{-|
Create an empty Query record
-}
newQuery : Query
newQuery =
    Dict.empty


{-|
Create a empty Address record
-}
newAddress : Address
newAddress =
    { query = newQuery
    , path = []
    }
