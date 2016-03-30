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

-}
resolveLocation : Config route -> String -> ( route, Location )
resolveLocation config locationString =
  let
    _ =
      Debug.log "routerSignal locationString" locationString
  in
    Matchers.matchLocation config locationString


{-| @private
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
  Signal.merge pathSignal hashSignal
