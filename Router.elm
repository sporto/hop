module Router where

import Erl
import String
import History
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Debug
import Html

type alias View = (({}) -> ({}) -> Html.Html)
type alias RouteDefinition = (String, View)
type alias ApplicationAction = ({})
type alias ApplicationModel = ({})

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
    viewHandler = viewHandler
  }

update: Action -> ({}, Effects Action)
update action =
  case action of
    GoToRoute route ->
      -- What models should we return here?
      -- Return the fx to change the route
      Debug.log "GoToRoute"
      ({}, goToRoute route)
    GoToRouteResult result ->
      -- Called after the route is changed
      -- Do nothing
      Debug.log "GoToRouteResult"
      ({}, Effects.none)
    RouteChanged url ->
      Debug.log "Router.RouteChanged"
      ({}, Effects.none)
    _ ->
      Debug.log "Router.NoOp"
      ({}, Effects.none)

---- We need our own mailbox
---- because start app doesnt expose its signal
---- we need this signal in hashChangeSignal
--routerMailbox: Signal.Mailbox Action
--routerMailbox = Signal.mailbox NoOp

viewHandler: Signal.Address ApplicationAction -> ApplicationModel -> Html.Html
viewHandler address model =
  notFoundView address model
  --let
  --  route =
  --    matchedRoute model.routes model.url
  --  view =
  --    route
  --      |> snd
  --      |> Maybe.withDefault notFoundView
  --in
  --  view address model


--notFoundView: Html.Html
notFoundView address model =
  Html.div [] [
    Html.text "Not Found"
  ]

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

{- 
Each time the hash is changed get a signal
We need to pass this signal to the main application
-}
hashChangeSignal: Signal Action
hashChangeSignal =
  Signal.map  (\urlString -> RouteChanged (Erl.parse urlString)) History.hash

{-
  Given the routes and the current url
  Return the route tuple that matches
-}
matchedRoute: List RouteDefinition -> Erl.Url -> RouteDefinition
matchedRoute routes url =
  routes
    |> List.head
    |> Maybe.withDefault  ("", notFoundView)

--firstRoute routes url =
--  routes
--    |> List.head
--    |> Maybe.withDefault ("", notFoundView)


-- matchRoute: Erl.Url -> view
matchRoute routes url =
  routes
    |> List.head
    |> Maybe.withDefault ("", notFoundView)
    |> snd


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
