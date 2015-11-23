module Lib.Matcher where

import String
import Html
import Debug

--notFoundView: Html.Html
--notFoundView: Signal.Address () -> ApplicationModel -> Html.Html
notFoundView address model =
  Html.div [] [
    Html.text "Not Found"
  ]

{-
  Default router handler if not found
-}
defaultRouteConf =
  ("*", notFoundView)

---- "/users/:id" --> ["users", ":id"]
parseRouteFragment: String -> List String
parseRouteFragment route =
  let
    notEmpty x=
      not (String.isEmpty x)
  in    
    route
      |> String.split "/"
      |> List.filter notEmpty

--matchedView: List RouteDefinition -> Erl.Url -> View
matchedView routes url =
  snd (matchedRoute routes url)

{-
  Given the routes and the current url
  Return the route tuple that matches
-}

---- match the url model to a view as given by routes
--matchedRoute: List (String, a -> b -> Html.Html) -> Erl.Url -> (String, a -> b -> Html.Html)
matchedRoute routes url =
  routes
    |> List.filter (isRouteMatch url)
    |> List.head
    |> Maybe.withDefault defaultRouteConf

----isRouteMatch: Erl.Url -> (String, {}) -> Bool
isRouteMatch url routeDef =
  let
    currentFragment =
      url.fragment
    currentLen =
      List.length currentFragment
    definitionFragment =
      parseRouteFragment (fst routeDef)
    definitionFragmentLen =
      List.length definitionFragment
  in
    if currentLen == definitionFragmentLen then
      -- Todo match parts of fragment
      True
    else
      Debug.log (toString url)
      False
