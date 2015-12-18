module Example.Languages.Update where

import Effects exposing (Effects, Never)
import Debug
import Hop

import Example.Models as Models
import Example.Languages.Actions as Actions

update : Actions.Action -> List Models.Language -> Hop.Payload -> (List Models.Language, Effects Actions.Action)
update action languages routerPayload =
  case Debug.log "action" action of
    Actions.Show id ->
      let
        navAction =
          Hop.navigateTo ("/languages/" ++ id)
      in
        (languages, Effects.map Actions.HopAction navAction)
    Actions.SetQuery query ->
      (languages, Effects.map Actions.HopAction (Hop.setQuery routerPayload.url query))
    _ ->
      (languages, Effects.none)
