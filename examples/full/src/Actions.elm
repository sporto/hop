module Actions (..) where

import Hop.Types exposing (Location, Query)
import Languages.Actions
import Models exposing (Route)


type Action
  = HopAction ()
  | ApplyRoute ( Route, Location )
  | NavigateTo String
  | SetQuery Query
  | LanguagesAction Languages.Actions.Action
