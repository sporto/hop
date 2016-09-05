module Hop.Utils exposing (..)

import Regex

dedupSlash : String -> String
dedupSlash =
    Regex.replace Regex.All (Regex.regex "/+") (\_ -> "/")
