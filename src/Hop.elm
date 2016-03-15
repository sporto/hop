module Hop (Config, Router, Route, Query, Url, new) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Types
@docs Config, Router, Route, Query, Url

# Setup
@docs new

-}

import History
import Hop.Types as Types
import Hop.Matcher as Matcher
import Hop.Url exposing (newQuery)


---------------------------------------
-- TYPES


{-| Query
A Dict that holds query parameters

    Dict.Dict String String
-}
type alias Query =
  Types.Query


{-| Url
A Record that includes a `path` and a `query`

    {
      path: String,
      query: Query
    }
-}
type alias Url =
  Types.Url


{-| A route defintion
-}
type alias Route action =
  Types.Route action


{-| Configuration input for Hop.new
-}
type alias Config actionTag routeTag =
  Types.Config actionTag routeTag


{-| Router record created by Hop.new
-}
type alias Router actionTag =
  Types.Router actionTag



---------------------------------------
-- SETUP


{-| Create a Router

    router =
      Hop.new {
        routes = routes,
        action = Show,
        notFound = NotFound
      }
-}
new : Config actionTag routeTag -> Router actionTag
new config =
  { signal = actionTagSignal config
  , run = History.setPath ""
  , query = newQuery
  }



---------------------------------------
-- UTILS
{-
@private
Each time the hash is changed get a signal
We pass this signal to the main application
-}


actionTagSignal : Config actionTag routeTag -> Signal actionTag
actionTagSignal config =
  Signal.map config.action (routeTagAndQuerySignal config)


routeTagAndQuerySignal : Config actionTag routeTag -> Signal ( routeTag, Query )
routeTagAndQuerySignal config =
  let
    resolve location =
      Matcher.matchLocation config.routes config.notFound location
  in
    Signal.map resolve History.hash
