module App (..) where

import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Routing exposing (router)
import Actions exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)


init : ( AppModel, Effects Action )
init =
  ( newAppModel, Effects.none )


routerSignal : Signal Action
routerSignal =
  Signal.map RoutingAction router.signal


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
