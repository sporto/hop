module Update (..) where

import Debug
import Effects exposing (Effects)
import Hop.Navigate exposing (navigateTo, setQuery, clearQuery)
import Actions exposing (..)
import Models exposing (..)
import Users.Update


update : Action -> AppModel -> ( AppModel, Effects Action )
update action model =
  case Debug.log "action" action of
    UsersAction subAction ->
      let
        updateModel =
          { users = model.users
          , location = model.location
          , routerConfig = model.routerConfig
          }

        ( updatedModel, fx ) =
          Users.Update.update subAction updateModel
      in
        ( { model | users = updatedModel.users }, Effects.map UsersAction fx )

    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo model.routerConfig path) )

    ApplyRoute ( route, location ) ->
      ( { model | route = route, location = location }, Effects.none )

    SetQuery query ->
      ( model, Effects.map HopAction (setQuery model.routerConfig query model.location) )

    ClearQuery ->
      ( model, Effects.map HopAction (clearQuery model.routerConfig model.location) )

    HopAction () ->
      ( model, Effects.none )
