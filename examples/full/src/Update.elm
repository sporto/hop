module Update (..) where

import Debug
import Effects exposing (Effects)
import Hop.Navigate exposing (navigateTo, setQuery)
import Actions exposing (..)
import Models exposing (..)
import Routing.Config
import Languages.Update


update : Action -> AppModel -> ( AppModel, Effects Action )
update action model =
  case Debug.log "action" action of
    LanguagesAction subAction ->
      let
        updateModel =
          { languages = model.languages
          , location = model.location
          }

        ( updatedModel, fx ) =
          Languages.Update.update subAction updateModel
      in
        ( { model | languages = updatedModel.languages }, Effects.map LanguagesAction fx )

    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo Routing.Config.config path) )

    ApplyRoute ( route, location ) ->
      ( { model | route = route, location = location }, Effects.none )

    SetQuery query ->
      ( model, Effects.map HopAction (setQuery Routing.Config.config query model.location) )

    HopAction () ->
      ( model, Effects.none )
