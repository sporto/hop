module Hop (new) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Setup
@docs new

-}

import History
import Hop.Types exposing (..)
import Hop.Matcher as Matcher


{-| Create a Router

    router =
      Hop.new {
        routes = routes,
        notFoundAction = ShowNotFound
      }
-}
new : Config wrapper action -> Router wrapper
new config =
  { signal = wrapperActionSignal config
  , run = History.setPath ""
  }



{-
@private
Each time the hash is changed get a signal
We pass this signal to the main application
-}


wrapperActionSignal : Config wrapper action -> Signal wrapper
wrapperActionSignal config =
  Signal.map config.wrapperAction (actionAndQuerySignal config)


actionAndQuerySignal : Config wrapper action -> Signal ( action, Query )
actionAndQuerySignal config =
  let
    resolve location =
      Matcher.matchLocation config.routes config.notFoundAction location
  in
    Signal.map resolve History.hash
