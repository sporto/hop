module Users.Status exposing (..)

import Html exposing (..)
import Users.Messages exposing (..)


view : Int -> Html Msg
view userId =
    div []
        [ h1 [] [ text ("Users.Status " ++ (toString userId)) ] ]
