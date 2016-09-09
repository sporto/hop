module Hop.Types exposing (Config, Query, Address, newQuery, newAddress)

{-| Types used in Hop

#Types
@docs Config, Address, Query

#Factories
@docs newQuery, newAddress
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

- basePath: Only for pushState routing (not hash). e.g. "/app".
- hash: True for hash routing, False for pushState routing.

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
Create an empty Address record
-}
newAddress : Address
newAddress =
    { query = newQuery
    , path = []
    }
