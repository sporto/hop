module Hop (new) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Setup
@docs new

-}

import Task exposing (Task)
import History
import Hop.Matchers as Matchers
import Hop.Types exposing (..)
import Hop.Location exposing (hrefToLocation)


---------------------------------------
-- SETUP
---------------------------------------


{-|
Create a Router

    config =
      { basePath = "/app"
      , hash = False
      , matchers = matchers
      , notFound = NotFound
      }

    router =
      Hop.new config
-}
new : Config routeTag -> Router routeTag
new config =
  { run = run config
  , signal = routerSignal config
  }



---------------------------------------
-- UTILS
---------------------------------------


{-| @priv
Initial task to match the initial route
-}
run : Config route -> Task error ()
run config =
  History.replacePath ""


{-| @priv

-}
resolveLocation : Config route -> Location -> ( route, Location )
resolveLocation config location =
  ( Matchers.matchLocation config location, location )


{-| @priv
Each time the location is changed get a signal (route, location)
We pass this signal to the main application
-}
routerSignal : Config routeTag -> Signal ( routeTag, Location )
routerSignal config =
  let
    signal =
      locationSignal config
  in
    Signal.map (resolveLocation config) signal


locationSignal : Config route -> Signal Location
locationSignal config =
  Signal.map (hrefToLocation config) History.href
