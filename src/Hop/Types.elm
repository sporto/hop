module Hop.Types (Config, Router, Route, Query, Url) where

{-|
@docs Config, Router, Route, Query, Url
-}

import Dict
import Task exposing (Task)
import Combine exposing (Parser)


{-| A Dict that holds query parameters

    Dict.Dict String String
-}
type alias Query =
  Dict.Dict String String


{-| A Record that includes a `path` and a `query`

    {
      path: String,
      query: Query
    }
-}
type alias Url =
  { path : List String
  , query : Query
  }


{-| A route defintion
-}
type alias Route action =
  { parser : Parser action
  , segments : List String
  }


{-| Configuration input for Hop.new
-}
type alias Config actionTag routeTag =
  { action : ( routeTag, Url ) -> actionTag
  , notFound : routeTag
  , routes : List (Route routeTag)
  }


{-| Router record created by Hop.new
-}
type alias Router actionTag =
  { signal : Signal actionTag
  , run : Task () ()
  , url : Url
  }
