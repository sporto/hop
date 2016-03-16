module Hop (new) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Setup
@docs new

-}

import History
import Hop.Matchers as Matchers
import Hop.Types exposing (..)


---------------------------------------
-- SETUP


{-|
Create a Router

    router =
      Hop.new {
        matchers = matchers,
        action = Show,
        notFound = NotFound
      }
-}
new : Config actionTag routeTag -> Router actionTag
new config =
  { signal = actionTagSignal config
  , run = History.setPath ""
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


routeTagAndQuerySignal : Config actionTag routeTag -> Signal ( routeTag, Location )
routeTagAndQuerySignal config =
  let
    resolve location =
      Matchers.matchLocation config.matchers config.notFound location
  in
    Signal.map resolve History.hash
