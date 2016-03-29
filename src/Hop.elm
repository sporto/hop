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
        notFound = NotFound
      }
-}
new : Config routeTag -> Router routeTag
new config =
  { run = History.setPath ""
  , signal = routerSignal config
  }



---------------------------------------
-- UTILS


{-| @private
Each time the hash is changed get a signal
We pass this signal to the main application
-}
routerSignal : Config routeTag -> Signal ( routeTag, Location )
routerSignal config =
  let
    signal =
      locationSignal config

    resolve location =
      let
        _ =
          Debug.log "routerSignal location" location
      in
        Matchers.matchLocation config.matchers config.notFound location
  in
    Signal.map resolve signal


locationSignal : Config route -> Signal String
locationSignal config =
  if config.hash then
    History.hash
  else
    History.path
