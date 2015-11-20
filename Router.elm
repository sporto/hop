module Router where

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Debug
import Html

--type alias View = Signal.Address ApplicationAction -> () -> Html.Html
--type alias RouteDefinition = (String, View)
--type alias ApplicationAction = ()
--type alias ApplicationModel = ()

type Action
  = NoOp
  | GoToRoute String
  | GoToRouteResult (Result () ())
  | RouteChanged Erl.Url

--  = ChangeRoute String
--  | GoToRouteResult (Result () ())
--  | RouteChanged Erl.Url

--new config =
--  let 
--    routerMailbox =
--      Signal.mailbox NoOp
--  in
--    {
--      address = routerMailbox.address,
--      signal =  routerMailbox.signal
--    }

new config =
  {
    signal = hashChangeSignal,
    viewHandler = viewHandler config.routes
  }

--update: Action -> ({}, Effects Action)
update action currentUrl =
  case action of
    GoToRoute route ->
      -- What models should we return here?
      -- Return the fx to change the route
      Debug.log "GoToRoute"
      (currentUrl, goToRoute route)
    GoToRouteResult result ->
      -- Called after the route is changed
      -- Do nothing
      Debug.log "GoToRouteResult"
      (currentUrl, Effects.none)
    RouteChanged url ->
      Debug.log "Router.RouteChanged"
      (url, Effects.none)
    _ ->
      Debug.log "Router.NoOp"
      (currentUrl, Effects.none)

---- We need our own mailbox
---- because start app doesnt expose its signal
---- we need this signal in hashChangeSignal
--routerMailbox: Signal.Mailbox Action
--routerMailbox = Signal.mailbox NoOp




--notFoundView: Html.Html
--notFoundView: Signal.Address () -> ApplicationModel -> Html.Html
notFoundView address model =
  Html.div [] [
    Html.text "Not Found"
  ]

---- "/users/1" --> ["users", "1"]
parseRouteFragment: String -> List String
parseRouteFragment route =
  let
    notEmpty x=
      not (String.isEmpty x)
  in    
    route
      |> String.split "/"
      |> List.filter notEmpty

{- 
Each time the hash is changed get a signal
We need to pass this signal to the main application
-}
hashChangeSignal: Signal Action
hashChangeSignal =
  Signal.map  (\urlString -> RouteChanged (Erl.parse urlString)) History.hash

--viewHandler: Signal.Address ApplicationAction -> ApplicationModel -> Html.Html

viewHandler routes address model =
  let
    view =
      matchedView routes model.url
  in
    view address model

{-
  Default router handler if not found
-}
defaultRouteConf =
  ("*", notFoundView)

--matchedView: List RouteDefinition -> Erl.Url -> View
matchedView routes url =
  snd (matchedRoute routes url)

{-
  Given the routes and the current url
  Return the route tuple that matches
-}

---- match the url model to a view as given by routes
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


-- Changes the hash
-- Maybe this should return Effects.none
goToRoute: String -> (Effects Action)
goToRoute route =
  History.setPath route
    |> Task.toResult
    |> Task.map GoToRouteResult
    |> Effects.task
