module TestActions.Lib where

import Maybe

type Action
  = LibAction1
  | LibAction2

--type UserAction action =
--  action

run: List action -> action -> action
run actions notFound =
  actions
    |> List.head
    |> Maybe.withDefault notFound

new config =
  { 
    run  = run config.actions config.notFound
  }
