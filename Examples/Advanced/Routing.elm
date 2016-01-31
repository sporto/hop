module Examples.Advanced.Routing where

import Effects exposing (Effects, Never)
import Dict
import Hop

type Action
  = HopAction Hop.Action
  | ShowLanguages Hop.Payload
  | ShowLanguage Hop.Payload
  | EditLanguage Hop.Payload
  | ShowAbout Hop.Payload
  | ShowNotFound Hop.Payload
  | NavigateTo String
  | SetQuery (Dict.Dict String String)
  | NoOp

type alias Model = {
    routerPayload: Hop.Payload,
    view: String
  }

newModel : Model
newModel = 
  {
    routerPayload = router.payload,
    view = "Main"
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NavigateTo path ->
      (model, Effects.map HopAction (Hop.navigateTo path))
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
    SetQuery query ->
      (model, Effects.map HopAction (Hop.setQuery query model.routerPayload.url))
    _ ->
      (model, Effects.none)

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
