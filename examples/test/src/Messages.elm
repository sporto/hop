module Messages exposing (..)

import Hop.Types exposing (Location, Query)
import Users.Messages


type Msg
    = NavigateTo String
    | SetQuery Query
    | ClearQuery
    | UsersAction Users.Messages.Msg
