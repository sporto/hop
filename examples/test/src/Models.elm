module Models (..) where

import Hop.Types exposing (Location, newLocation)
import Users.Models exposing (User)


type Route
  = HomeRoute
  | AboutRoute
  | UsersRoutes Users.Models.Route
  | NotFoundRoute


type alias AppModel =
  { location : Location
  , route : Route
  , users : List User
  }


newAppModel : AppModel
newAppModel =
  { location = newLocation
  , route = AboutRoute
  , users = []
  }
