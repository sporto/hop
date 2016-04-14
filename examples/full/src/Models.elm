module Models (..) where

import Hop.Types exposing (Location, newLocation)
import Languages.Models exposing (Language, languages)


type Route
  = HomeRoute
  | AboutRoute
  | LanguagesRoutes Languages.Models.Route
  | NotFoundRoute


type alias AppModel =
  { languages : List Language
  , location : Location
  , route : Route
  , selectedLanguage : Maybe Language
  }


newAppModel : AppModel
newAppModel =
  { languages = languages
  , location = newLocation
  , route = AboutRoute
  , selectedLanguage = Maybe.Nothing
  }
