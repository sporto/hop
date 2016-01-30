module Hop.Normalizer where

import String
import Regex
import Dict

import Hop.Types as Types

{-
Normalizer
Prepares a route to be send to History
-}

{-
  Given a route by the user, prepare it for sending it to History
-}
prepareRoute : String -> String
prepareRoute route =
  let
    afterHash =
      route
        |> String.split "#"
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""
  in
    if String.startsWith "/" afterHash then
      "#" ++ afterHash
    else
      "#/" ++ afterHash
