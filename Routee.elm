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

type alias Config action model = {
    routes: List (String, action),
    update: (action -> model -> (model, Effects action)),
    notFoundAction: action
  }

type alias Library action model = {
    signal: Signal Action,
    update: Action -> model -> (model, Effects Action)
  }

new: Config action model -> Library action model
new config =
  {
    signal = hashChangeSignal,
    update = update config.routes config.notFoundAction config.update
  }

--update: Action -> ({}, Effects Action)
--update: List (String, action) -> action -> (action -> model -> (model, Effects action)) -> Action -> appModel -> (appModel, Effects Action)
update routes notFoundAction userUpdate routerAction appModel =
  case routerAction of
    GoToRoute route ->
      (appModel, goToRouteFx route)
    GoToRouteResult result ->
      (appModel, Effects.none)
    RouteChanged url ->
      let
        userAction =
          actionForUrl routes notFoundAction url
        (updatedAppModel, fx) =
          userUpdate userAction appModel
      in
        Debug.log "RouteChanged"
        (updatedAppModel, Effects.none)
    _ ->
      Debug.log "Router.NoOp"
      (appModel, Effects.none)  


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
goToRouteFx: String -> (Effects Action)
goToRouteFx route =
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
