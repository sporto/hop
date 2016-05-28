module Messages exposing (..)

import Hop.Types exposing (Location, Query)
import Languages.Messages
import Models exposing (Route)


type Msg
    = NavigateTo String
    | SetQuery Query
    | LanguagesMsg Languages.Messages.Msg
