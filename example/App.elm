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
import Example.Models as Models
import Example.Languages.Actions as LanguageActions
import Example.Languages.Update as LanguageUpdate
import Example.Languages.Filter as LanguageFilter
import Example.Languages.List as LanguageList
import Example.Languages.Show as LanguageShow
import Example.Languages.Edit as LanguageEdit

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

zeroModel : Model
zeroModel =
  {
    routerPayload = router.payload,
    selectedUser = Models.User "" "",
    users = [user1, user2],
    view = "",
    languages = Models.languages,
    selectedLanguage = Maybe.Nothing
  }

type Action
  = HopAction Hop.Action
  | LanguageAction LanguageActions.Action
  | ShowLanguages Hop.Payload
  | ShowLanguage Hop.Payload
  | EditLanguage Hop.Payload
  | ShowAbout Hop.Payload
  | ShowNotFound Hop.Payload
  | NavigateTo String
  | NoOp

init : (Model, Effects Action)
init =
  (zeroModel, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NavigateTo path ->
      (model, Effects.map HopAction (Hop.navigateTo path))
    LanguageAction subAction ->
      let
        (languages, fx) =
          LanguageUpdate.update subAction model.languages model.routerPayload
      in
        ({model | languages = languages}, Effects.map LanguageAction fx)
    ShowLanguage payload ->
      ({model | view = "language", routerPayload = payload}, Effects.none)
    EditLanguage payload ->
      ({model | view = "languageEdit", routerPayload = payload}, Effects.none)
    ShowLanguages payload ->
      ({model | view = "languages", routerPayload = payload}, Effects.none)
    ShowAbout payload ->
      ({model | view = "about", routerPayload = payload}, Effects.none)
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
    menu address model,
    pageView address model
  ]

--languageListItem : Signal.Address Action ->  -> H.Html

menu : Signal.Address Action -> Model -> H.Html
menu address model =
  H.div [] [
    H.div [] [
      menuLink "#/" "Languages",
      H.text "|",
      menuLink "#/about" "About"
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

pageView : Signal.Address Action -> Model -> H.Html
pageView address model =
  case model.view of
    "about" ->
      H.div [] [
        H.h2 [] [ H.text "About" ]
      ]
    _ ->
      H.div [ containerStyle ] [
        LanguageFilter.view (Signal.forwardTo address LanguageAction) model.languages model.routerPayload,
        LanguageList.view (Signal.forwardTo address LanguageAction) model.languages model.routerPayload,
        subView address model
      ]

subView : Signal.Address Action -> Model -> H.Html
subView address model =
  case model.view of
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
    "languageEdit" ->
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
            LanguageEdit.view (Signal.forwardTo address LanguageAction) language
          _ ->
            emptyView
    "notFound" ->
      notFoundView address model
    _ ->
      emptyView

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

notFoundView: Signal.Address Action -> Model -> H.Html
notFoundView address model =
  H.div [] [
    H.text "Not Found"
  ]

-- ROUTING

routes : List (String, Hop.Payload -> Action)
routes =
  [
    ("/", ShowLanguages),
    ("/languages/:id", ShowLanguage),
    ("/languages/:id/edit", EditLanguage),
    ("/about", ShowAbout)
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
