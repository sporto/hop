module Users.Actions (..) where

import Dict


type Action
  = Show Int
  | ShowStatus Int
  | AddQuery (Dict.Dict String String)
  | SetQuery (Dict.Dict String String)
  | NavigateTo String
  | HopAction ()
