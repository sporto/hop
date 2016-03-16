module Routing (..) where

import Effects exposing (Effects)
import Debug
import Hop
import Hop.Types exposing (Url, Query, Route, Router)
import Hop.Builder exposing (..)
import Hop.Navigation exposing (navigateTo, setQuery)
import Languages.Models exposing (LanguageId)


type View
  = About
  | Languages
  | Language LanguageId
  | LanguageEdit LanguageId
  | NotFound


type Action
  = HopAction ()
  | Show ( View, Url )
  | NavigateTo String
  | SetQuery Query


type alias Model =
  { url : Url
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



--routeAbout :


routeAbout =
  route1 About "/about"


routes : List (Route View)
routes =
  [ route1 About "/about"
  , route1 Languages "/"
  , route2 Language "/languages/" int
  , route3 LanguageEdit "/languages/" int "/edit"
  ]


router : Router Action
router =
  Hop.new
    { routes = routes
    , action = Show
    , notFound = NotFound
    }
