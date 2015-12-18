module Example.Languages.Actions where

import Hop
import Dict

type Action
  = NoOp
  | Show String
  | HopAction Hop.Action
  | SetQuery (Dict.Dict String String)
