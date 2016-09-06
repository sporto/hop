module Languages.Routing.Config exposing (..)

import Languages.Models exposing (..)
import UrlParser exposing ((</>), int, s, string)


matchers : List (UrlParser.Parser (Route -> a) a)
matchers =
    [ UrlParser.format LanguageEditRoute (int </> s "edit")
    , UrlParser.format LanguageRoute (int)
    , UrlParser.format LanguagesRoute (s "")
    ]
