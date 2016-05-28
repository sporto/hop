module Languages.Messages exposing (..)

import Dict
import Languages.Models exposing (..)
import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)


type alias Prop =
    String


type alias Value =
    String


type Msg
    = Show LanguageId
    | Edit LanguageId
    | Update LanguageId Prop Value
    | AddQuery (Dict.Dict String String)
    | SetQuery (Dict.Dict String String)
