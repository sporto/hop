module ExampleApp where

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
import Routee

--type alias View = Signal.Address Action -> AppModel -> H.Html

type alias AppModel = {
  count: Int,
  url: Erl.Url,
  view: String
}
                      
zeroModel: AppModel
zeroModel =
  {
    count = 1,
    url = Erl.new,
    view = ""
  }

type Action
  = RouterAction Routee.Action
  | Increment
  | ShowUser
  | ShowUsers
  | ShowNotFound
  | NoOp

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
        (updatedModel, fx) = router.update routerAction model
      in
        (updatedModel, Effects.map RouterAction fx)
    ShowUsers ->
      Debug.log "ShowUsers"
      ({model | view <- "users"}, Effects.none)
    ShowUser ->
      Debug.log "ShowUser"
      ({model | view <- "user"}, Effects.none)
    _ ->
      (model, Effects.none)

view: Signal.Address Action -> AppModel -> H.Html
view address model =
  H.div [] [
    H.text "Hello",
    H.text (toString model.count),
    menu address model,
    maybeUseView address model,
    maybeUsesView address model
  ]

menu: Signal.Address Action -> AppModel -> H.Html
menu address model =
  H.div [] [
    H.button [ Html.Events.onClick address (Increment) ] [
      H.text "Count"
    ],
    -- Here we should change the route in a nicer way
    H.button [ Html.Events.onClick address (RouterAction (Routee.GoToRoute "#users")) ] [
      H.text "Users"
    ],
    H.button [ Html.Events.onClick address (RouterAction (Routee.GoToRoute "#users/1")) ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1" ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1/edit" ] [
      H.text "User 1 edit"
    ]
  ]

maybeUsesView: Signal.Address Action -> AppModel -> H.Html
maybeUsesView address model =
  case model.view of
    "users" ->
      usersView address model
    _ ->
      H.div [] []

usersView: Signal.Address Action -> AppModel -> H.Html
usersView address model =
  H.div [] [
    H.text "Users"
  ]

maybeUseView: Signal.Address Action -> AppModel -> H.Html
maybeUseView address model =
  case model.view of
    "user" ->
      userView address model
    _ ->
      H.div [] []

userView: Signal.Address Action -> AppModel -> H.Html
userView address model =
  H.div [] [
    H.text "User"
  ]

notFoundView: Signal.Address Action -> AppModel -> H.Html
notFoundView address model =
  H.div [] [
    H.text "Not Found"
  ]

-- ROUTING

--routes: List (String, View)
routes =
  [
    ("/users", ShowUsers),
    ("/users/:id", ShowUser)
  ]

router = 
  Routee.new {
    routes = routes,
    notFoundAction = ShowNotFound,
    update = update
  }

{- 
In order to listen to hash changes
Application has to include the signal coming from the router
router.signal needs to resolve to an application signal
router.Action != Action
-}
routerSignal =
  Signal.map (\action -> RouterAction action) router.signal

app =
  StartApp.start {
    init = init,
    update = update,
    view = view,
    inputs = [routerSignal]
  }

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


