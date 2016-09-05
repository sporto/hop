module Hop.Types exposing (Config, Query, Address)

import Dict


type alias Query =
    Dict.Dict String String


type alias Address =
    { path : List String
    , query : Query
    }


type alias Config route =
    { basePath : String
    , hash : Bool
    , notFound : route
    }
