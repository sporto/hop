import UrlParser exposing ((</>), oneOf, int, s)

type alias LanguageId = Int

type LanguageRoute
    = LanguagesRoute
    | LanguageRoute LanguageId
    | LanguageEditRoute LanguageId

type MainRoute
    = HomeRoute
    | AboutRoute
    | LanguagesRoutes LanguageRoute

languagesMatchers = 
    [ UrlParser.format LanguagesRoute (s "")
    , UrlParser.format LanguageEditRoute (int </> s "edit")
    ]

mainMatchers =
    [ UrlParser.format HomeRoute (s "")
    , UrlParser.format AboutRoute (s "about")
    , UrlParser.format LanguagesRoutes (s "languages" </> (oneOf languagesMatchers))
    ]

parser =
    oneOf mainMatchers
