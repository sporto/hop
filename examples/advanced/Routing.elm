module Routing (..) where

import Effects exposing (Effects, Never)
import Hop
import Hop.Builder exposing (..)
import Hop.Navigation exposing (navigateTo, setQuery)


type View
  = About
  | Languages
  | Language Int
  | LanguageEdit Int
  | NotFound


type Action
  = HopAction ()
  | Show ( View, Hop.Url )
  | NavigateTo String
  | SetQuery Hop.Query


type alias Model =
  { url : Hop.Url
  , view : View
  }


newModel : Model
newModel =
  { url = router.url
  , view = Languages
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    Show ( view, url ) ->
      ( { model | view = view, url = url }, Effects.none )

    SetQuery query ->
      ( model, Effects.map HopAction (setQuery query model.url) )

    HopAction () ->
      ( model, Effects.none )


routes : List (Hop.Route View)
routes =
  [ route1 About "/about"
  , route1 Languages "/"
  , route2 Language "/languages/" int
  , route3 LanguageEdit "/languages/" int "/edit"
  ]


router : Hop.Router Action
router =
  Hop.new
    { routes = routes
    , action = Show
    , notFound = NotFound
    }
