module Lib.Utils where

import String 

{-
Take the route defintion and return a List
"/users/:id" --> ["users", ":id"]
-}
parseRouteFragment: String -> List String
parseRouteFragment route =
  let
    notEmpty x=
      not (String.isEmpty x)
  in
    route
      |> String.split "/"
      |> List.filter notEmpty
