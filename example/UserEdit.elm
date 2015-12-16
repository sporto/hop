module Example.UserEdit where

import Html as H
import Html.Events
import Effects exposing (Effects, Never)
import Hop

import Example.Models as Models

type Action
  = Save
  | HopAction Hop.Action
  | Show String
  | Cancel

update : Action -> Models.User -> (Models.User, Effects Action)
update action user =
  case action of
    Show id ->
      (user, Effects.map HopAction (Hop.navigateTo ("/users/" ++ id)))
    _ ->
      (user, Effects.none)

view : Signal.Address Action -> Models.User -> H.Html
view address model =
  H.div [] [
    H.text ("User Edit " ++ model.name),
    H.button [ Html.Events.onClick address (Show model.id) ] [
      H.text "Show"
    ]
  ]
