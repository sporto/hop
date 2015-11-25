module TestActions.App where

import Html
import TestActions.Lib as Lib

type Action
  = AppAction
  | AppAction2


actions =
  [AppAction]

lib = Lib.new actions

main: Html.Html
main = 
  Html.text lib
