module Hop (new) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Setup
@docs new

-}

import Task exposing (Task)
import History
import Hop.Matchers as Matchers
import Hop.Types exposing (..)


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



-- REFACTOR
-- 1. Convert incoming History signal to location record
-- 2. Match location record, not string
-- 3. Return tuple (route, location)


{-| @priv

-}
resolveLocation : Config route -> String -> ( route, Location )
resolveLocation config locationString =
  Matchers.matchLocation config locationString


{-| @priv
Each time the location is changed get a signal (route, location)
We pass this signal to the main application
-}
routerSignal : Config routeTag -> Signal ( routeTag, Location )
routerSignal config =
  let
    signal =
      locationSignal config

    loggedSignal =
      Signal.map (Debug.log "routerSignal") signal
  in
    Signal.map (resolveLocation config) loggedSignal


{-|
Given a complete href extract the part relevant to the current routing
-}
extractPath : Config route -> String -> String
extractPath config href =
  let
    _ =
      Debug.log "href" href
  in
    href


locationSignal : Config route -> Signal String
locationSignal config =
  Signal.map (extractPath config) History.href
