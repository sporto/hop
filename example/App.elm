module Example.App where

import Html as H
import Html.Events
import Dict
import Debug

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href)
import Task exposing (Task)
import Erl
import Routee
import Example.UserEdit as UserEdit
import Example.Models as Models

--type alias View = Signal.Address Action -> AppModel -> H.Html

type alias AppModel = {
  count: Int,
  routeParams: Dict.Dict String String,
  selectedUser: Models.User,
  url: Erl.Url,
  users: Models.UserList,
  view: String
}

user1 : Models.User
user1 =
  Models.User "1" "Sam"

user2 : Models.User
user2 =
  Models.User "2" "Sally"

zeroModel : AppModel
zeroModel =
  {
    count = 1,
    routeParams = Dict.empty,
    selectedUser = Models.User "" "",
    url = Erl.new,
    users = [user1, user2],
    view = ""
  }

type Action
  = RouterAction Routee.Action
  | Increment
  | NavigateTo String
  | UserEditAction UserEdit.Action
  | ShowUsers Routee.Params
  | ShowUser Routee.Params
  | ShowUserEdit Routee.Params
  | ShowNotFound Routee.Params
  | NoOp

init : (AppModel, Effects Action)
init =
  (zeroModel, Effects.none)

update : Action -> AppModel -> (AppModel, Effects Action)
update action model =
  case action of
    Increment ->
      ({model | count = model.count + 1 }, Effects.none)
    NavigateTo path ->
      (model, Effects.map RouterAction (router.navigateTo path))
    --RouterAction routerAction ->
    --  let
    --    (updatedModel, fx) = router.update routerAction model
    --  in
    --    (updatedModel, Effects.map RouterAction fx)
    UserEditAction subAction ->
      let
        (user, fx) =
          UserEdit.update subAction model.selectedUser
      in
        ({model | selectedUser = user}, Effects.map UserEditAction fx)
    ShowUsers params ->
      ({model | view = "users", routeParams = params}, Effects.none)
    ShowUser params ->
      Debug.log "ShowUser"
      ({model | view = "user", routeParams = params}, Effects.none)
    ShowUserEdit params ->
      ({model | view = "userEdit", routeParams = params}, Effects.none)
    _ ->
      (model, Effects.none)

view : Signal.Address Action -> AppModel -> H.Html
view address model =
  H.div [] [
    H.text (toString model.count),
    menu address model,
    H.h2 [] [
      H.text "Rendered view:"
    ],
    maybeUsersView address model,
    maybeUserView address model,
    maybeUseEditView address model
  ]

menu : Signal.Address Action -> AppModel -> H.Html
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
    menuBtn address "#users/1/edit" "User Edit 1",
    menuBtn address "#users/2/edit" "User Edit 2",

    H.span [] [ H.text " Plain a tags: " ],
    menuLink "#/users" "Users",
    H.text "|",
    menuLink "#/users/1" "User 1",
    H.text "|",
    menuLink "#/users/2" "User 2",
    H.text "|",
    menuLink "#/users/2/edit" "User 1 edit"
  ]

menuBtn : Signal.Address Action -> String -> String -> H.Html
menuBtn address path label =
 H.button [ Html.Events.onClick address (NavigateTo path) ] [
  H.text label
 ]

menuLink : String -> String -> H.Html
menuLink path label =
 H.a [ href path ] [
    H.text label
  ]

maybeUsersView : Signal.Address Action -> AppModel -> H.Html
maybeUsersView address model =
  case model.view of
    "users" ->
      usersView address model
    _ ->
      H.div [] []

usersView : Signal.Address Action -> AppModel -> H.Html
usersView address model =
  H.div [] [
    H.text "Users"
  ]

maybeUserView : Signal.Address Action -> AppModel -> H.Html
maybeUserView address model =
  case model.view of
    "user" ->
      userView address model
    _ ->
      H.div [] []

maybeUseEditView : Signal.Address Action -> AppModel -> H.Html
maybeUseEditView address model =
  case model.view of
    "userEdit" ->
      let
        userId =
          model.routeParams
            |> Dict.get "id"
            |> Maybe.withDefault ""
        maybeSelectedUser =
          getUser model.users userId
      in
        case maybeSelectedUser of
          Just user ->
            UserEdit.view (Signal.forwardTo address UserEditAction) user
          _ ->
            emptyView
    _ ->
      emptyView

userView : Signal.Address Action -> AppModel -> H.Html
userView address model =
  let
    userId =
      Dict.get "id" model.routeParams |> Maybe.withDefault ""
  in
    H.div [] [
      H.text ("User " ++ userId)
    ]

emptyView : H.Html
emptyView =
  H.div [] []

getUser: Models.UserList -> String -> Maybe Models.User
getUser users id =
  users
    |> List.filter (\user -> user.id == id)
    |> List.head

notFoundView: Signal.Address Action -> AppModel -> H.Html
notFoundView address model =
  H.div [] [
    H.text "Not Found"
  ]

-- ROUTING

--routes : List (String, Action)
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
    theAction = ShowUser
  }

app =
  StartApp.start {
    init = init,
    update = update,
    view = view,
    inputs = [router.signal]
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


