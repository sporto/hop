module Routee where

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Debug
import Html
import Lib.Matcher

--type alias StartAppView a b = Signal.Address a -> b -> Html.Html
--type alias RouteDefinition = (String, View)
--type alias ApplicationAction = ()
--type alias ApplicationModel = ()

--type Handler appView
--  = View appView
--  | TestHandler String

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

--new: { routes: List (String, Handler) } -> {}
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
      Lib.Matcher.matchedView routes model.url
  in
    view address model

-- Changes the hash
-- Maybe this should return Effects.none
goToRoute: String -> (Effects Action)
goToRoute route =
  History.setPath route
    |> Task.toResult
    |> Task.map GoToRouteResult
    |> Effects.task
