module Actions (..) where

import Hop.Types exposing (Location, Query)
import Users.Actions
import Models exposing (Route)


type Action
  = HopAction ()
  | ApplyRoute ( Route, Location )
  | NavigateTo String
  | SetQuery Query
  | ClearQuery
  | UsersAction Users.Actions.Action
