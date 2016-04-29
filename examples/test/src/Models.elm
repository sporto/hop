module Models (..) where

import Hop.Types exposing (Config, Location, newLocation)
import Users.Models exposing (User)


type Route
  = HomeRoute
  | AboutRoute
  | UsersRoutes Users.Models.Route
  | NotFoundRoute


type alias AppModel =
  { routerConfig : Config Route
  , location : Location
  , route : Route
  , users : List User
  }

type alias AppConfig = 
  { basePath: String
  , hash: Bool
  }

newAppModel : Config Route -> AppModel
newAppModel routerConfig =
  { routerConfig = routerConfig
  , location = newLocation
  , route = AboutRoute
  , users = []
  }
