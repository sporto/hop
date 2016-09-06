module Messages exposing (..)

import Hop.Types exposing (Query)
import Languages.Messages


type Msg
    = SetQuery Query
    | LanguagesMsg Languages.Messages.Msg
    | ShowHome
    | ShowLanguages
    | ShowAbout
