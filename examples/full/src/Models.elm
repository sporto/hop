module Models exposing (..)

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


newAppModel : Route -> Hop.Types.Location -> AppModel
newAppModel route location =
    { languages = languages
    , location = location
    , route = route
    , selectedLanguage = Maybe.Nothing
    }
