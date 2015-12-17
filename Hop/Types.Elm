module Hop.Types where

import Dict
import Erl
import Task exposing (Task)


type alias Params = Dict.Dict String String

type alias Payload = {
    params: Params,
    url: Erl.Url
  }

type alias UserPartialAction action = Payload -> action

type alias Config partialAction = {
    notFoundAction: partialAction,
    routes: List (RouteDefinition partialAction)
  }

type alias Router action = {
    signal: Signal action,
    payload: Payload,
    run: Task () ()
  }

type alias RouteDefinition action = (String, action)
