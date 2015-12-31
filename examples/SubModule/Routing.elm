module Examples.SubModule.Routing where

import Effects exposing (Effects, Never)
import Hop

type Action
  = HopAction Hop.Action
  | ShowAbout Hop.Payload
  | ShowMain Hop.Payload
  | ShowContact Hop.Payload
  | ShowNotFound Hop.Payload

type alias Model = {
    routerPayload: Hop.Payload,
    view: String
  }

zeroModel : Model
zeroModel =
  {
    routerPayload = router.payload,
    view = "Main"
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ShowMain payload ->
      ({model | view = "main", routerPayload = payload}, Effects.none)
    ShowAbout payload ->
      ({model | view = "about", routerPayload = payload}, Effects.none)
    ShowContact payload ->
      ({model | view = "contact", routerPayload = payload}, Effects.none)
    _ ->
      (model, Effects.none)

routes : List (String, Hop.Payload -> Action)
routes =
  [
    ("/", ShowMain),
    ("/main", ShowMain),
    ("/about", ShowAbout),
    ("/contact", ShowContact)
  ]


router : Hop.Router Action
router =
  Hop.new {
    routes = routes,
    notFoundAction = ShowNotFound
  }

