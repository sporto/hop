-- Try to integrate wih start app

{-- TODO

- Match route on init
- Pass query string to view
- Pass query string to update
- Match parts of fragment
- Pass fragment params to view e.g :id
-}

module App where

import Html as H
import Html.Events
import Debug
import String

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href)
import History
import Task exposing (Task)
import Erl
import Router

type alias AppModel = {
  count: Int,
  url: Erl.Url
}
                      
zeroModel: AppModel
zeroModel =
  {
    count = 1,
    url = Erl.new
  }

type Action
  = RouteChanged Erl.Url
  | RouterAction Router.Action
  | Increment
  | NoOp

-- TODO: match route on init
init: (AppModel, Effects Action)
init =
  (zeroModel, Effects.none)

update: Action -> AppModel -> (AppModel, Effects Action)
update action model =
  case action of
    Increment ->
      ({model | count <- model.count + 1 }, Effects.none)
    RouterAction routerAction ->
      let
        (updated, fx) = Router.update routerAction
      in
        Debug.log "RouterAction"
        (model, Effects.map RouterAction fx)
    RouteChanged url ->
      -- Here we should receive a route model
      ({model | count <- model.count + 1 , url <- url }, Effects.none)
    _ ->
      Debug.log "_"
      (model, Effects.none)

view: Signal.Address Router.Action -> Signal.Address Action -> AppModel -> H.Html
view routerAddress address model =
  H.div [] [
    H.text "Hello",
    H.text (toString model.count)
    , menu routerAddress address model
    --, viewHandler routerAddress address model
  ]

menu: Signal.Address Router.Action -> Signal.Address Action -> AppModel -> H.Html
menu routerAddress address model =
  H.div [] [
    H.button [ Html.Events.onClick address (Increment) ] [
      H.text "Count"
    ],
    -- Here we should change the route in a nicer way
    H.button [ Html.Events.onClick address (RouterAction (Router.GoToRoute "#users")) ] [
      H.text "Users"
    ],
    H.button [ Html.Events.onClick address (RouterAction (Router.GoToRoute "#users/1")) ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1" ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1/edit" ] [
      H.text "User 1 edit"
    ]
  ]

usersView: Signal.Address Router.Action -> Signal.Address Action -> AppModel -> H.Html
usersView routerAddress address model =
  H.div [] [
    H.text "Users"
  ]

userView: Signal.Address Router.Action -> Signal.Address Action -> AppModel -> H.Html
userView routerAddress address model =
  H.div [] [
    H.text "User"
  ]

notFoundView: Signal.Address Router.Action -> Signal.Address Action -> AppModel -> H.Html
notFoundView routerAddress address model =
  H.div [] [
    H.text "Not Found"
  ]

-- ROUTING

-- Todo initial matching
routes =
  [
    ("/users", usersView),
    ("/users/:id", userView),
    ("*", notFoundView)
  ]

router = 
  Router.new {
    routes = routes
  }

-----

--router.signal needs to resolve to an application signal
-- router.Action != Action

routerSignal =
  Signal.map (\_ -> NoOp) router.signal

app =
  StartApp.start {
    init = init,
    update = update,
    view = (view router.address),
    inputs = [routerSignal]
  }

-- Effects

main: Signal H.Html
main =
  app.html

-- What is missing?
  -- Convert hash paths to a model
  -- Create hash paths easily

-- this is the important bit
port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


