module Example.Languages.Actions where

import Hop

type Action
  = NoOp
  | Show String
  | HopAction Hop.Action
