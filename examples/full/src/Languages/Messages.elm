module Languages.Messages exposing (..)

import Dict
import Languages.Models exposing (..)


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
