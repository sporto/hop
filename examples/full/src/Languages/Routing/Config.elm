module Languages.Routing.Config exposing (..)

import Languages.Models exposing (..)
import UrlParser exposing ((</>), int, s)

matchers : List (UrlParser.Parser (Route -> a) a)
matchers =
    [ UrlParser.format LanguagesRoute (s "")
    , UrlParser.format LanguageEditRoute (int </> s "edit")
    ]
