module TestActions.Lib where

import Maybe

type Action
  = LibAction
  | LibAction2

choose actions =
  actions
    |> List.head
    |> Maybe.withDefault LibAction

new actions =
  toString (choose actions)
