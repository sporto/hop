module Hop.Normalizer where

import String
import Regex
import Dict
import Debug
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
  route

-- queryComponent : String -> String
-- queryComponent route =
--   if String.contains "?" route then
--     route
--       |> String.split "?"
--       |> List.drop 1
--       |> List.head
--       |> Maybe.withDefault ""
--       |> String.split "#"
--       |> List.head
--       |> Maybe.withDefault ""
--       |> String.append "?"
--     else
--       ""

{-
  Cleans up url
-}
--normalizedUrl : String -> String
--normalizedUrl route =
--  let
--    query =
--      queryComponent route
--    --withoutQuery =
--    --  Regex.replace Regex.All (Regex.regex query) (always "") route
--    afterHash =
--      if String.contains "#" route then
--        route
--          |> String.split "#"
--          |> List.reverse
--          |> List.head
--          |> Maybe.withDefault ""
--      else
--        if String.contains "?" route then
--          ""
--        else
--          route
--    hashComponent =
--      if String.startsWith "/" afterHash then
--        "#" ++ afterHash
--      else
--        "#/" ++ afterHash
--  in
--    query ++ hashComponent
