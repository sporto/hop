module Example.App where

import Html as H
import Html.Events
import Dict
import Debug

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href, style)
import Task exposing (Task)
import Debug
import Hop
import Example.UserEdit as UserEdit
import Example.Models as Models
import Example.Languages.Actions as LanguageActions
import Example.Languages.Update as LanguageUpdate
import Example.Languages.List as LanguageList
import Example.Languages.Show as LanguageShow

--type alias View = Signal.Address Action -> Model -> H.Html

type alias Model = {
  routerPayload: Hop.Payload,
  selectedUser: Models.User,
  users: Models.UserList,
  view: String,
  languages: List Models.Language,
  selectedLanguage: Maybe Models.Language
}

user1 : Models.User
user1 =
  Models.User "1" "Sam"

user2 : Models.User
user2 =
  Models.User "2" "Sally"

languages : List Models.Language
languages =
  [
    {id = "1", name = "Elm", image = "elm"},
    {id = "2", name = "JavaScript", image = "js"},
    {id = "3", name = "Go", image = "go"},
    {id = "4", name = "Rust", image = "rust"},
    {id = "5", name = "Elixir", image = "elixir"},
    {id = "6", name = "Ruby", image = "ruby"},
    {id = "7", name = "Python", image = "python"},
    {id = "8", name = "Swift", image = "swift"},
    {id = "9", name = "Haskell", image = "haskell"},
    {id = "10", name = "Java", image = "java"},
    {id = "11", name = "C#", image = "csharp"},
    {id = "12", name = "PHP", image = "php"}
  ]

zeroModel : Model
zeroModel =
  {
    routerPayload = router.payload,
    selectedUser = Models.User "" "",
    users = [user1, user2],
    view = "",
    languages = languages,
    selectedLanguage = Maybe.Nothing
  }

type Action
  = HopAction Hop.Action
  | LanguageAction LanguageActions.Action
  | ShowLanguage Hop.Payload
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

init : (Model, Effects Action)
init =
  (zeroModel, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NavigateTo path ->
      (model, Effects.map HopAction (Hop.navigateTo path))
    SetQuery query ->
      (model, Effects.map HopAction (Hop.setQuery model.routerPayload.url query))
    ClearQuery ->
      (model, Effects.map HopAction (Hop.clearQuery model.routerPayload.url))
    LanguageAction subAction ->
      let
        (languages, fx) =
          LanguageUpdate.update subAction model.languages
      in
        ({model | languages = languages}, Effects.map LanguageAction fx)
    UserEditAction subAction ->
      let
        (user, fx) =
          UserEdit.update subAction model.selectedUser
      in
        ({model | selectedUser = user}, Effects.map UserEditAction fx)
    ShowLanguage payload ->
      ({model | view = "language", routerPayload = payload}, Effects.none)
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

containerStyle : H.Attribute
containerStyle =
  style
    [
      ("margin-bottom", "5rem"),
      ("overflow", "auto")
    ]      

view : Signal.Address Action -> Model -> H.Html
view address model =
  H.div [] [
    H.div [ containerStyle ] [
      LanguageList.view (Signal.forwardTo address LanguageAction) model.languages,
      subView address model
    ],
    menu address model
  ]

--languageListItem : Signal.Address Action ->  -> H.Html

menu : Signal.Address Action -> Model -> H.Html
menu address model =
  H.div [] [
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

subView : Signal.Address Action -> Model -> H.Html
subView address model =
  case Debug.log "model.view" model.view of
    "language" ->
      let
        languageId =
          model.routerPayload.params
            |> Dict.get "id"
            |> Maybe.withDefault ""
        maybeLanguage =
          getLanguage model.languages languageId
      in
        case maybeLanguage of
          Just language ->
            LanguageShow.view (Signal.forwardTo address LanguageAction) language
          _ ->
            emptyView
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


usersView : Signal.Address Action -> Model -> H.Html
usersView address model =
  H.div [] [
    H.text "Users"
  ]

userView : Signal.Address Action -> Model -> H.Html
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

getLanguage: List Models.Language -> String -> Maybe Models.Language
getLanguage languages id =
  languages
    |> List.filter (\lang -> lang.id == id)
    |> List.head

searchView: Signal.Address Action -> Model -> H.Html
searchView address model =
  let
    keyword =
      Dict.get "keyword" model.routerPayload.params |> Maybe.withDefault ""
  in
    H.div [] [
      H.text ("Search " ++ keyword)
    ]

notFoundView: Signal.Address Action -> Model -> H.Html
notFoundView address model =
  H.div [] [
    H.text "Not Found"
  ]

-- ROUTING

routes : List (String, Hop.Payload -> Action)
routes =
  [
    ("/languages/:id", ShowLanguage),
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

app : StartApp.App Model
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
