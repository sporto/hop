module Example.App where

import Html as H
import Html.Events
import Dict
import Debug

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href)
import Task exposing (Task)
import Debug
import Hop
import Example.UserEdit as UserEdit
import Example.Models as Models

--type alias View = Signal.Address Action -> AppModel -> H.Html

type alias AppModel = {
  count: Int,
  routerPayload: Hop.Payload,
  selectedUser: Models.User,
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
    routerPayload = router.payload,
    selectedUser = Models.User "" "",
    users = [user1, user2],
    view = ""
  }

type Action
  = HopAction Hop.Action
  | Increment
  | NavigateTo String
  | SetQuery (Dict.Dict String String)
  | ClearQuery
  | UserEditAction UserEdit.Action
  | ShowUsers Hop.Payload
  | ShowUser Hop.Payload
  | ShowUserEdit Hop.Payload
  | ShowSearch Hop.Payload
  | ShowNotFound Hop.Payload
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
      (model, Effects.map HopAction (Hop.navigateTo path))
    SetQuery query ->
      (model, Effects.map HopAction (Hop.setQuery model.routerPayload.url query))
    ClearQuery ->
      (model, Effects.map HopAction (Hop.clearQuery model.routerPayload.url))
    UserEditAction subAction ->
      let
        (user, fx) =
          UserEdit.update subAction model.selectedUser
      in
        ({model | selectedUser = user}, Effects.map UserEditAction fx)
    ShowUsers payload ->
      ({model | view = "users", routerPayload = payload}, Effects.none)
    ShowUser payload ->
      Debug.log "ShowUser"
      ({model | view = "user", routerPayload = payload}, Effects.none)
    ShowUserEdit payload ->
      ({model | view = "userEdit", routerPayload = payload}, Effects.none)
    ShowSearch payload ->
      ({model | view = "search", routerPayload = payload}, Effects.none)
    ShowNotFound payload ->
      ({model | view = "notFound", routerPayload = payload}, Effects.none)
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
    subView address model
  ]

menu : Signal.Address Action -> AppModel -> H.Html
menu address model =
  H.div [] [
    H.button [ Html.Events.onClick address (Increment) ] [
      H.text "Count"
    ],
    H.div [] [
      H.div [] [ H.text "Using actions: " ],
      -- Here we should change the route in a nicer way
      menuBtn address (NavigateTo "/users") "Users",
      menuBtn address (NavigateTo "/users/1") "User 1",
      menuBtn address (NavigateTo "/users/2") "User 2",
      menuBtn address (NavigateTo "/users/1/edit") "User Edit 1",
      menuBtn address (NavigateTo "/users/2/edit") "User Edit 2",
      H.br [] [],
      menuBtn address (NavigateTo "/search?keyword=elm") "Go to search with query",
      menuBtn address (SetQuery (Dict.singleton "color" "red")) "Add to query `color=red`",
      menuBtn address (SetQuery (Dict.singleton "size" "big")) "Add to query `size=big`",
      menuBtn address (SetQuery (Dict.singleton "color" "")) "Clear query `color`",
      menuBtn address (ClearQuery) "Clear all query"
    ],

    H.div [] [
      H.div [] [ H.text "Plain a tags: " ],
      menuLink "#/users" "Users",
      H.text "|",
      menuLink "#/users/1" "User 1",
      H.text "|",
      menuLink "#/users/2" "User 2",
      H.text "|",
      menuLink "#/users/2/edit" "User 1 edit"
    ]
  ]

menuBtn : Signal.Address Action -> Action -> String -> H.Html
menuBtn address action label =
 H.button [ Html.Events.onClick address action ] [
  H.text label
 ]

menuLink : String -> String -> H.Html
menuLink path label =
 H.a [ href path ] [
    H.text label
  ]

subView : Signal.Address Action -> AppModel -> H.Html
subView address model =
  case model.view of
    "users" ->
      usersView address model
    "user" ->
      userView address model
    "userEdit" ->
      let
        userId =
          model.routerPayload.params
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
    "search" ->
      searchView address model
    "notFound" ->
      notFoundView address model
    _ ->
      emptyView


usersView : Signal.Address Action -> AppModel -> H.Html
usersView address model =
  H.div [] [
    H.text "Users"
  ]

userView : Signal.Address Action -> AppModel -> H.Html
userView address model =
  let
    userId =
      Dict.get "id" model.routerPayload.params |> Maybe.withDefault ""
    color =
      Dict.get "color" model.routerPayload.params |> Maybe.withDefault ""
  in
    H.div [] [
      H.text ("User " ++ userId ++ " " ++ color)
    ]

emptyView : H.Html
emptyView =
  H.div [] []

getUser: Models.UserList -> String -> Maybe Models.User
getUser users id =
  users
    |> List.filter (\user -> user.id == id)
    |> List.head

searchView: Signal.Address Action -> AppModel -> H.Html
searchView address model =
  let
    keyword =
      Dict.get "keyword" model.routerPayload.params |> Maybe.withDefault ""
  in
    H.div [] [
      H.text ("Search " ++ keyword)
    ]

notFoundView: Signal.Address Action -> AppModel -> H.Html
notFoundView address model =
  H.div [] [
    H.text "Not Found"
  ]

-- ROUTING

routes : List (String, Hop.UserPartialAction Action)
routes =
  [
    ("/users", ShowUsers),
    ("/users/:id", ShowUser),
    ("/users/:id/edit", ShowUserEdit),
    ("/search", ShowSearch)
  ]

router : Hop.Router Action
router = 
  Hop.new {
    routes = routes,
    notFoundAction = ShowNotFound
  }

app : StartApp.App AppModel
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

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

port routeRunTask : Task () ()
port routeRunTask =
  router.run
