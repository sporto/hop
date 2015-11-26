module TestActions.App where

import Html
import TestActions.Lib as Lib

type Action
  = AppAction1
  | AppAction2
  | NotFound
  | LibAction

actions =
  [AppAction1, AppAction2]

lib = 
  Lib.new {
    actions = actions,
    notFound = NotFound
  }

main: Html.Html
main = 
  case lib.run of
    AppAction1 ->
      Html.text "AppAction1"
    AppAction2 ->
      Html.text "AppAction2"
    NotFound -> 
      Html.text "NotFound"
