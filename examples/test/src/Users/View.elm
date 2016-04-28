module Users.View (..) where

import Html exposing (..)
import Hop.Types exposing (Location)
import Users.Models exposing (User, Route, Route(..))
import Users.Actions exposing (..)
import Users.List
import Users.Show
import Users.Status


type alias ViewModel =
  { location : Location
  , route : Route
  , users : List User
  }


view : Signal.Address Action -> ViewModel -> Html
view address model =
  case model.route of
    UsersRoute ->
      Users.List.view address []

    UserRoute userId ->
      Users.Show.view address userId

    UserStatusRoute userId ->
      Users.Status.view address userId

    NotFoundRoute ->
      notFoundView address model


emptyView : Html
emptyView =
  span [] []


notFoundView : Signal.Address Action -> ViewModel -> Html
notFoundView address model =
  div
    []
    [ text "Not Found"
    ]
