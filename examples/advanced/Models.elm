module Models (..) where

import Routing
import Languages.Models exposing (Language, languages)


type alias AppModel =
  { routing : Routing.Model
  , languages : List Language
  , selectedLanguage : Maybe Language
  }


newAppModel : AppModel
newAppModel =
  { routing = Routing.newModel
  , languages = languages
  , selectedLanguage = Maybe.Nothing
  }
