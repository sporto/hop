module Actions (..) where

import Routing
import Languages.Actions


type Action
  = RoutingAction Routing.Action
  | LanguagesAction Languages.Actions.Action
