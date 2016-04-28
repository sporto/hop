module Users.List (..) where

import Html exposing (..)
import Users.Models exposing (..)
import Users.Actions exposing (..)


view : Signal.Address Action -> List User -> Html
view address user =
  div
    []
    [ h1 [] [ text "Users.List" ] ]
