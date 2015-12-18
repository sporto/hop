module Example.Languages.Update where

import Effects exposing (Effects, Never)
import Hop

import Example.Models as Models
import Example.Languages.Actions as Actions

update : Actions.Action -> List Models.Language -> (List Models.Language, Effects Actions.Action)
update action languages =
  case action of
    Actions.Show id ->
      let
        navAction =
          Hop.navigateTo ("/languages/" ++ id)
      in
        (languages, Effects.map Actions.HopAction navAction)
    _ ->
      (languages, Effects.none)
