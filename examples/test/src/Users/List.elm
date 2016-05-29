module Users.List exposing (..)

import Html exposing (..)
import Users.Models exposing (..)
import Users.Messages exposing (..)


view : List User -> Html Msg
view user =
    div []
        [ h1 [] [ text "Users.List" ] ]
