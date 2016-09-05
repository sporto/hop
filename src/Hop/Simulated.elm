module Hop.Simulated exposing(..)

import Hop.Types
import Hop.Address
import Hop.Utils
import Hop.Real

toAddress : String -> Hop.Types.Address
toAddress =
    Hop.Address.parse

{-|
Make a real path from a simulated path.
This will add the hash and the basePath as necessary.

    toRealPath config "/users"

    ==

    "#/users"
-}
toRealPath : Hop.Types.Config route -> String -> String
toRealPath config path =
    path
        |> Hop.Address.parse
        |> Hop.Real.fromAddress config
