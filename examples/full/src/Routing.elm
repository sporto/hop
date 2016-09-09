module Routing exposing (..)

import Models exposing (..)
import Hop.Types exposing (Config)
import Languages.Routing
import UrlParser exposing ((</>), oneOf, int, s)
import Languages.Routing


matchers : List (UrlParser.Parser (Route -> a) a)
matchers =
    [ UrlParser.format HomeRoute (s "")
    , UrlParser.format AboutRoute (s "about")
    , UrlParser.format LanguagesRoutes (s "languages" </> (oneOf Languages.Routing.matchers))
    ]


routes : UrlParser.Parser (Route -> a) a
routes =
    oneOf matchers


config : Config
config =
    { basePath = "/app"
    , hash = False
    }

reverse : Route -> String
reverse route =
    case route of
        HomeRoute ->
            ""

        AboutRoute ->
            "about"

        LanguagesRoutes subRoute ->
            "languages" ++ Languages.Routing.reverse subRoute

        NotFoundRoute ->
            ""
