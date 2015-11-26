module Routee where

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Debug
import Html
--import Lib.Matcher
--import Lib.Actions as Actions

type Action
  = NoOp
  | GoToRoute String
  | GoToRouteResult (Result () ())
  | RouteChanged Erl.Url


--type alias StartAppView a b = Signal.Address a -> b -> Html.Html
--type alias RouteDefinition = (String, View)
--type alias ApplicationAction = ()
--type alias ApplicationModel = ()

--type Handler appView
--  = View appView
--  | TestHandler String

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

type alias Config action = {
    routes: List (String, action),
    notFoundAction: action
  }

type alias Library action = {
    signal: Signal Action,
    update: Action -> Erl.Url -> (Erl.Url, Effects Action)
  }

new: Config action -> Library action
new config =
  {
    signal = hashChangeSignal,
    update = update config.routes config.notFoundAction
  }

--update: Action -> ({}, Effects Action)
update: List (String, action) -> action -> Action -> Erl.Url -> (Erl.Url, Effects Action)
update routes notFoundAction action currentUrl =
  case action of
    GoToRoute route ->
      -- What models should we return here?
      -- Return the fx to change the route
      --Debug.log "GoToRoute"
      (currentUrl, goToRoute route)
      --(currentUrl,  Effects.none)
    GoToRouteResult result ->
      -- Called after the route is changed
      -- Do nothing
      --Debug.log "GoToRouteResult"
      (currentUrl, Effects.none)
      -- I think the user needs to provide a function here
      -- that changes the model
    RouteChanged url ->
      let
        userAction =
          actionForUrl routes notFoundAction url
        fx =
          --Effects.none
          Task.succeed userAction
            |> Effects.task
      in
        (url, fx)
      -- Called after changing the hash
      -- Manually or through an interaction
      -- We need to call the proper update function for the user
      --let
      --  userAction =
      --    actionForUrl notFoundAction routes url
      --  fx =
      --    Effects.none
      --    --Task.succeed userAction
      --    --  |> Effects.task
      --in
      --  --Debug.log "Router.RouteChanged"
      --  (url, fx)
    _ ->
      Debug.log "Router.NoOp"
      (currentUrl, Effects.none)  

---- We need our own mailbox
---- because start app doesnt expose its signal
---- we need this signal in hashChangeSignal
--routerMailbox: Signal.Mailbox Action
--routerMailbox = Signal.mailbox NoOp




{- 
Each time the hash is changed get a signal
We need to pass this signal to the main application
-}
hashChangeSignal: Signal Action
hashChangeSignal =
  Signal.map  (\urlString -> RouteChanged (Erl.parse urlString)) History.hash

--userAction: Signal.Address ApplicationAction -> ApplicationModel -> Html.Html

--userAction routes address model =
--  Lib.Matcher.actionForUrl routes model.url

-- Changes the hash
-- Maybe this should return Effects.none
goToRoute: String -> (Effects Action)
goToRoute route =
  History.setPath route
    |> Task.toResult
    |> Task.map GoToRouteResult
    |> Effects.task

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

--actionForUrl: List RouteDefinition -> Erl.Url -> View
actionForUrl routes notFoundAction url =
  matchedRoute routes url
    |> Maybe.withDefault ("", notFoundAction)
    |> snd

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
      --Debug.log (toString url)
      False
