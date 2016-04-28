module Users.Show (..) where

import Html exposing (..)
import Users.Actions exposing (..)


view : Signal.Address Action -> Int -> Html
view address userId =
  div
    []
    [ h1 [] [ text ("Users.Show " ++ (toString userId)) ] ]
