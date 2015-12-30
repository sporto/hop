module Examples.Basic.Languages.Update where

import Effects exposing (Effects, Never)
import Debug
import Hop

import Examples.Basic.Models as Models
import Examples.Basic.Languages.Actions as Actions

update : Actions.Action -> List Models.Language -> Hop.Payload -> (List Models.Language, Effects Actions.Action)
update action languages routerPayload =
  case Debug.log "action" action of
    Actions.Show id ->
      let
        navAction =
          Hop.navigateTo ("/languages/" ++ id)
      in
        (languages, Effects.map Actions.HopAction navAction)
    Actions.Edit id ->
      let
        navAction =
          Hop.navigateTo ("/languages/" ++ id ++ "/edit")
        in
          (languages, Effects.map Actions.HopAction navAction)
    Actions.Update id prop value ->
      -- need to update the language here
      let udpatedLanguages =
        List.map (updateWithId id prop value) languages
      in
      (udpatedLanguages, Effects.none)
    Actions.AddQuery query ->
      (languages, Effects.map Actions.HopAction (Hop.addQuery routerPayload.url query))
    Actions.SetQuery query ->
      (languages, Effects.map Actions.HopAction (Hop.setQuery routerPayload.url query))
    _ ->
      (languages, Effects.none)

updateWithId id prop value language =
  if id == language.id then
    case prop of
      "name" ->
        {language | name = value}
      _ ->
          language
  else
    language
