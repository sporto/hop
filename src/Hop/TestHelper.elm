module Hop.TestHelper exposing (..)

import Hop.Types exposing (Config)


configWithHash : Config
configWithHash =
    { basePath = ""
    , hash = True
    }


configWithPath : Config
configWithPath =
    { basePath = ""
    , hash = False
    }


configPathAndBasePath : Config
configPathAndBasePath =
    { basePath = "/app/v1"
    , hash = False
    }
