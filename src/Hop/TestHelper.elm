module Hop.TestHelper exposing (..)

import Hop.Types exposing (Config)


config : Config
config =
    { basePath = ""
    , hash = True
    }


configWithPath : Config
configWithPath =
    { config | hash = False }


configPathAndBasePath : Config
configPathAndBasePath =
    { configWithPath | basePath = "/app/v1" }
