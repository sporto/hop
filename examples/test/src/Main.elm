module Main (..) where

import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Hop
import Hop.Types exposing (Config, Router)
import Actions exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)
import Routing.Config


getRouterConfig : Config Route
getRouterConfig =
  Routing.Config.getConfig config.basePath config.hash


init : ( AppModel, Effects Action )
init =
  ( newAppModel getRouterConfig, Effects.none )


router : Router Route
router =
  Hop.new getRouterConfig


routerSignal : Signal Action
routerSignal =
  Signal.map ApplyRoute router.signal


app : StartApp.App AppModel
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ routerSignal ]
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


port routeRunTask : Task () ()
port routeRunTask =
  router.run


port config : AppConfig
