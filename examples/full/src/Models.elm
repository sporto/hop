module Models exposing (..)

import Hop.Types exposing (Address, newAddress)
import Languages.Models exposing (Language, languages)


type Route
    = HomeRoute
    | AboutRoute
    | LanguagesRoutes Languages.Models.Route
    | NotFoundRoute


type alias AppModel =
    { languages : List Language
    , address : Address
    , route : Route
    , selectedLanguage : Maybe Language
    }


newAppModel : Route -> Address -> AppModel
newAppModel route address =
    { languages = languages
    , address = address
    , route = route
    , selectedLanguage = Maybe.Nothing
    }
