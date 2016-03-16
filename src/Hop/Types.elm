module Hop.Types (Config, Router, PathMatcher, Query, Url) where

{-|
@docs Config, Router, PathMatcher, Query, Url
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


{-| A matcher for a path
-}
type alias PathMatcher action =
  { parser : Parser action
  , segments : List String
  }


{-| Configuration input for Hop.new
-}
type alias Config actionTag routeTag =
  { action : ( routeTag, Url ) -> actionTag
  , notFound : routeTag
  , matchers : List (PathMatcher routeTag)
  }


{-| Router record created by Hop.new
-}
type alias Router actionTag =
  { signal : Signal actionTag
  , run : Task () ()
  , url : Url
  }
