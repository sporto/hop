module Hop.Types exposing (Config, Query, Location)

import Dict


type alias Query =
    Dict.Dict String String


type alias Location =
    { path : List String
    , query : Query
    }


type alias Config route =
    { basePath : String
    , hash : Bool
    , notFound : route
    }
