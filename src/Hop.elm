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


{-| @priv
combinedLocationSignal filtered depending on config.hash
-}
locationSignal : Config route -> Signal String
locationSignal config =
  let
    filter ( kind, path ) =
      case kind of
        Path ->
          config.hash == False

        Hash ->
          config.hash == True

    extract ( kind, path ) =
      path
  in
    combinedLocationSignal
      |> Signal.filter filter ( Path, "" )
      |> Signal.map extract


type HistoryKind
  = Path
  | Hash


pathSignal : Signal ( HistoryKind, String )
pathSignal =
  Signal.map (\path -> ( Path, path )) History.path


hashSignal : Signal ( HistoryKind, String )
hashSignal =
  Signal.map (\path -> ( Hash, path )) History.hash


combinedLocationSignal : Signal ( HistoryKind, String )
combinedLocationSignal =
  let
    signal =
      Signal.merge pathSignal hashSignal

    loggedSignal =
      Signal.map (Debug.log "combinedLocationSignal") signal
  in
    loggedSignal
