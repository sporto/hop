module Examples.Advanced.Languages.Actions where

import Hop
import Dict

type alias Id = String
type alias Prop = String
type alias Value = String

type Action
  = NoOp
  | Show String
  | Edit String
  | Update Id Prop Value
  | HopAction Hop.Action
  | AddQuery (Dict.Dict String String)
  | SetQuery (Dict.Dict String String)
