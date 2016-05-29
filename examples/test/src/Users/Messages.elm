module Users.Messages exposing (..)

import Dict


type Msg
    = Show Int
    | ShowStatus Int
    | AddQuery (Dict.Dict String String)
    | SetQuery (Dict.Dict String String)
    | NavigateTo String
