module Update (..) where

import Effects exposing (Effects, Never)
import Routing
import Actions exposing (..)
import Models exposing (..)
import Languages.Update


update : Action -> AppModel -> ( AppModel, Effects Action )
update action model =
  case action of
    RoutingAction subAction ->
      let
        ( updatedRouting, fx ) =
          Routing.update subAction model.routing

        updatedModel =
          { model | routing = updatedRouting }
      in
        ( updatedModel, Effects.map RoutingAction fx )

    LanguagesAction subAction ->
      let
        updateModel =
          { languages = model.languages
          , url = model.routing.url
          }

        ( languages, fx ) =
          Languages.Update.update subAction updateModel
      in
        ( { model | languages = languages }, Effects.map LanguagesAction fx )
