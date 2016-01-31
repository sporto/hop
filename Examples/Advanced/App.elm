module Examples.Advanced.App where

import Html as H
import Html.Events
import Dict
import Debug
import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href, style)
import Task exposing (Task)
import Hop

import Examples.Advanced.Routing as Routing exposing(router)
import Examples.Advanced.Models as Models
import Examples.Advanced.Languages.Actions as LanguageActions
import Examples.Advanced.Languages.Update as LanguageUpdate
import Examples.Advanced.Languages.Filter as LanguageFilter
import Examples.Advanced.Languages.List as LanguageList
import Examples.Advanced.Languages.Show as LanguageShow
import Examples.Advanced.Languages.Edit as LanguageEdit

type alias Model = {
    routing: Routing.Model,
    selectedUser: Models.User,
    users: Models.UserList,
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
zeroModel = {
    routing = Routing.newModel,
    selectedUser = Models.User "" "",
    users = [user1, user2],
    languages = Models.languages,
    selectedLanguage = Maybe.Nothing
  }

type Action
  = NoOp
  | RoutingAction Routing.Action
  | LanguageAction LanguageActions.Action

init : (Model, Effects Action)
init =
  (zeroModel, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    RoutingAction subAction ->
      let
        (updatedRouting, fx) =
          Routing.update subAction model.routing
        updatedModel =
          { model | routing = updatedRouting }
      in
        (updatedModel, Effects.map RoutingAction fx)
    LanguageAction subAction ->
      let
        (languages, fx) =
          LanguageUpdate.update subAction model.languages model.routing.routerPayload
      in
        ({model | languages = languages}, Effects.map LanguageAction fx)
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
  case model.routing.view of
    "about" ->
      H.div [] [
        H.h2 [] [ H.text "About" ]
      ]
    _ ->
      H.div [ containerStyle ] [
        LanguageFilter.view (Signal.forwardTo address LanguageAction) model.languages model.routing.routerPayload,
        LanguageList.view (Signal.forwardTo address LanguageAction) model.languages model.routing.routerPayload,
        subView address model
      ]

subView : Signal.Address Action -> Model -> H.Html
subView address model =
  case model.routing.view of
    "language" ->
      let
        languageId =
          model.routing.routerPayload.params
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
          model.routing.routerPayload.params
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

routerSignal =
  Signal.map RoutingAction router.signal

app : StartApp.App Model
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

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

port routeRunTask : Task () ()
port routeRunTask =
  router.run
