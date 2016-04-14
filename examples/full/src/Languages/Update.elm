module Languages.Update (..) where

import Effects exposing (Effects, Never)
import Debug
import Task
import Hop.Navigate exposing (navigateTo, addQuery, setQuery)
import Hop.Types exposing (Config, Location)
import Routing.Config
import Models
import Languages.Models exposing (..)
import Languages.Actions exposing (Action, Action(..))
import Languages.Routing.Utils


type alias UpdateModel =
  { languages : List Language
  , location : Location
  }


routerConfig : Config Models.Route
routerConfig =
  Routing.Config.config


update : Action -> UpdateModel -> ( UpdateModel, Effects Action )
update action model =
  case Debug.log "action" action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo Routing.Config.config path) )

    Show id ->
      let
        path =
          Languages.Routing.Utils.reverseWithPrefix (Languages.Models.LanguageRoute id)

        fx =
          Task.succeed (NavigateTo path)
            |> Effects.task
      in
        ( model, fx )

    Edit id ->
      let
        path =
          Languages.Routing.Utils.reverseWithPrefix (Languages.Models.LanguageEditRoute id)

        fx =
          Task.succeed (NavigateTo path)
            |> Effects.task
      in
        ( model, fx )

    Update id prop value ->
      let
        udpatedLanguages =
          List.map (updateWithId id prop value) model.languages
      in
        ( { model | languages = udpatedLanguages }, Effects.none )

    AddQuery query ->
      let
        fx =
          Effects.map HopAction (addQuery routerConfig query model.location)
      in
        ( model, fx )

    SetQuery query ->
      let
        fx =
          Effects.map HopAction (setQuery routerConfig query model.location)
      in
        ( model, fx )

    HopAction () ->
      ( model, Effects.none )


updateWithId : LanguageId -> String -> String -> Language -> Language
updateWithId id prop value language =
  if id == language.id then
    case prop of
      "name" ->
        { language | name = value }

      _ ->
        language
  else
    language
