module Routing.Config exposing (..)

import Models exposing (..)
import Hop.Types exposing (Config)
import Languages.Routing.Config
import UrlParser exposing ((</>), oneOf, int, s)


matchers : List (UrlParser.Parser (Route -> a) a)
matchers =
    [ UrlParser.format HomeRoute (s "")
    , UrlParser.format AboutRoute (s "about")
    , UrlParser.format LanguagesRoutes (s "languages" </> (oneOf Languages.Routing.Config.matchers))
    ]


parser : UrlParser.Parser (Route -> a) a
parser =
    oneOf matchers


config : Config
config =
    { basePath = "/app"
    , hash = False
    }
