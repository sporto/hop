module Router where

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Debug

type Action
  = NoOp
  | GoToRoute String
  | GoToRouteResult (Result () ())

--  = ChangeRoute String
--  | GoToRouteResult (Result () ())
--  | RouteChanged Erl.Url

new config =
  let 
    routerMailbox =
      Signal.mailbox NoOp
  in
    {
      address = routerMailbox.address,
      signal =  routerMailbox.signal
    }
--    viewHandler = viewHandler

update: Action -> ({}, Effects Action)
update action =
  case action of
    GoToRoute route ->
      Debug.log "GoToRoute"
      ({}, goToRoute route)
    _ ->
      Debug.log "NoOp"
      ({}, Effects.none)

---- We need our own mailbox
---- because start app doesnt expose its signal
---- we need this signal in hashChangeSignal
--routerMailbox: Signal.Mailbox Action
--routerMailbox = Signal.mailbox NoOp

----viewHandler: Signal.Address Action -> Signal.Address Action -> AppModel -> H.Html
--viewHandler routerAddress address model =
--  let
--    view =
--      matchRoute model.routes model.url
--  in
--    view routerAddress address model

---- "/users/1" --> ["users", "1"]
--parseRouteFragment: String -> List String
--parseRouteFragment route =
--  let
--    notEmpty x=
--      not (String.isEmpty x)
--  in    
--    route
--      |> String.split "/"
--      |> List.filter notEmpty

---- Each time the hash is changed
---- get a signal
---- convert to model
---- pass to update function
--hashChangeSignal: Signal Action
--hashChangeSignal =
--  Signal.map  (\s -> RouteChanged (Erl.parse s)) History.hash

----matchRoute: Erl.Url -> view
---- match the url model to a view as given by routes
--matchRoute routes url =
--  routes
--    |> List.filter (isRouteMatch url)
--    |> List.head
--    |> Maybe.withDefault ("", notFoundView)
--    |> snd

----isRouteMatch: Erl.Url -> (String, {}) -> Bool
--isRouteMatch url routeDef =
--  let
--    currentFragment =
--      url.fragment
--    currentLen =
--      List.length currentFragment
--    defFragment =
--      parseRouteFragment (fst routeDef)
--    defFragmentLen =
--      List.length defFragment
--  in
--    if currentLen == defFragmentLen then
--      -- Todo match parts of fragment
--      True
--    else
--      False


-- Changes the hash
-- Maybe this should return Effects.none
goToRoute: String -> (Effects Action)
goToRoute route =
  History.setPath route
    |> Task.toResult
    |> Task.map GoToRouteResult
    |> Effects.task
