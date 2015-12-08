module ExampleApp where

import Html as H
import Html.Events
import Debug
import String
import Dict

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
  view: String,
  routeParams: Dict.Dict String String
}

zeroModel: AppModel
zeroModel =
  {
    count = 1,
    url = Erl.new,
    view = "",
    routeParams = Dict.empty
  }

type Action
  = RouterAction Routee.Action
  | Increment
  | ShowUsers Routee.Params
  | ShowUser Routee.Params
  | ShowUserEdit Routee.Params
  | ShowNotFound Routee.Params
  | NoOp

init: (AppModel, Effects Action)
init =
  (zeroModel, Effects.none)

update: Action -> AppModel -> (AppModel, Effects Action)
update action model =
  case action of
    Increment ->
      ({model | count = model.count + 1 }, Effects.none)
    RouterAction routerAction ->
      let
        (updatedModel, fx) = router.update routerAction model
      in
        (updatedModel, Effects.map RouterAction fx)
    ShowUsers params ->
      ({model | view = "users", routeParams = params}, Effects.none)
    ShowUser params ->
      ({model | view = "user", routeParams = params}, Effects.none)
    ShowUserEdit params ->
      ({model | view = "userEdit", routeParams = params}, Effects.none)
    _ ->
      (model, Effects.none)

view: Signal.Address Action -> AppModel -> H.Html
view address model =
  H.div [] [
    H.text (toString model.count),
    menu address model,
    H.h2 [] [
      H.text "Rendered view:"
    ],
    maybeUsesView address model,
    maybeUseView address model,
    maybeUseEditView address model
  ]

menu: Signal.Address Action -> AppModel -> H.Html
menu address model =
  H.div [] [
    H.button [ Html.Events.onClick address (Increment) ] [
      H.text "Count"
    ],

    H.span [] [ H.text "Using actions: " ],
    -- Here we should change the route in a nicer way
    menuBtn address "#users" "Users",
    menuBtn address "#users/1" "User 1",
    menuBtn address "#users/2" "User 2",
    menuBtn address "#users/2/edit" "User Edit 1",

    H.span [] [ H.text " Plain a tags: " ],
    menuLink "#/users" "Users",
    H.text "|",
    menuLink "#/users/1" "User 1",
    H.text "|",
    menuLink "#/users/2" "User 2",
    H.text "|",
    menuLink "#/users/2/edit" "User 1 edit"
  ]

menuBtn address path label =
 H.button [ Html.Events.onClick address (RouterAction (Routee.GoToRoute path)) ] [
  H.text label
 ]

menuLink path label =
 H.a [ href path ] [
    H.text label
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

maybeUseEditView: Signal.Address Action -> AppModel -> H.Html
maybeUseEditView address model =
  case model.view of
    "userEdit" ->
      userEditView address model
    _ ->
      H.div [] []

userView: Signal.Address Action -> AppModel -> H.Html
userView address model =
  let
    userId =
      Dict.get "id" model.routeParams |> Maybe.withDefault ""
  in
    H.div [] [
      H.text ("User " ++ userId)
    ]

userEditView: Signal.Address Action -> AppModel -> H.Html
userEditView address model =
  let
    userId =
      Dict.get "id" model.routeParams |> Maybe.withDefault ""
  in
    H.div [] [
      H.text ("User Edit " ++ userId)
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
    ("/users/:id", ShowUser),
    ("/users/:id/edit", ShowUserEdit)
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


