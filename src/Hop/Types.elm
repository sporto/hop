module Hop.Types (Config, Router, Route, Query, Url) where

{-| Hop.Types

@docs Config, Router, Route, Query, Url
-}

import Dict
import Task exposing (Task)
import Combine exposing (Parser)


{-| Actions
-}



--type Action
--  = GoToRouteResult (Result () ())


{-| Query
A Dict that holds query parameters

    Dict.Dict String String
-}
type alias Query =
  Dict.Dict String String


{-| Url
A Record that includes a `path` and a `query`

    {
      path: String,
      query: Query
    }
-}
type alias Url =
  { path : String
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
  { action : ( routeTag, Query ) -> actionTag
  , notFound : routeTag
  , routes : List (Route routeTag)
  }


{-| Router record created by Hop.new
-}
type alias Router action =
  { signal : Signal action
  , run : Task () ()
  }
