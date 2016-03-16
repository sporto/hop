module Actions (..) where

import Routing
import Languages.Actions


type Action
  = RoutingAction Routing.RoutingAction
  | LanguagesAction Languages.Actions.Action
