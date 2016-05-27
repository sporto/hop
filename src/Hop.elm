module Hop exposing (getUrl)

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Setup
@docs getUrl

-}

--import Task exposing (Task)
--import Hop.Matchers as Matchers

import Hop.Types exposing (..)
import Hop.Location


---------------------------------------
-- SETUP
---------------------------------------
-- {-|
-- Create a Router
--     config =
--       { basePath = "/app"
--       , hash = False
--       , matchers = matchers
--       , notFound = NotFound
--       }
--     router =
--       Hop.new config
-- -}
-- program : Config routeTag -> Router routeTag
-- program config =
--     Navigation.program urlParser
--       { init = init
--       , view = view
--       , update = update
--       , urlUpdate = urlUpdate
--       , subscriptions = subscriptions
--       }
-- { run = run config
-- , signal = routerSignal config
-- }
---------------------------------------
-- UTILS
---------------------------------------
-- {-| @priv
-- Initial task to match the initial route
-- -}
-- run : Config route -> Task error ()
-- run config =
--   History.replacePath ""
-- {-| @priv
-- -}
-- resolveLocation : Config route -> Location -> ( route, Location )
-- resolveLocation config location =
--   ( Matchers.matchLocation config location, location )
-- {-| @priv
-- Each time the location is changed get a signal (route, location)
-- We pass this signal to the main application
-- -}
-- routerSignal : Config routeTag -> Signal ( routeTag, Location )
-- routerSignal config =
--   let
--     signal =
--       locationSignal config
--   in
--     Signal.map (resolveLocation config) signal
-- locationSignal : Config route -> Signal Location
-- locationSignal config =
--   Signal.map (hrefToLocation config) History.href


{-| Create a url from ...

  navigateTo will append "#/" if necessary

    navigateTo config "/users"

  Example use in update:

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (navigateTo config path))
-}
getUrl : Config route -> String -> String
getUrl config route =
    route
        |> Hop.Location.locationFromUser
        |> getUrlFromLocation config


{-| @private
Create an url from a location
-}
getUrlFromLocation : Config route -> Location -> String
getUrlFromLocation config location =
    let
        fullPath =
            Hop.Location.locationToFullPath config location

        path =
            if fullPath == "" then
                "/"
            else
                fullPath
    in
        path
