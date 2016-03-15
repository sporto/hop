module Languages.Actions (..) where

import Dict
import Languages.Models exposing (..)


type alias Prop =
  String


type alias Value =
  String


type Action
  = Show LanguageId
  | Edit LanguageId
  | Update LanguageId Prop Value
  | HopAction ()
  | AddQuery (Dict.Dict String String)
  | SetQuery (Dict.Dict String String)
