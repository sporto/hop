module Languages.Update (..) where

import Effects exposing (Effects, Never)
import Debug
import Hop
import Hop.Navigation exposing (navigateTo, addQuery, setQuery)
import Languages.Models exposing (..)
import Languages.Actions exposing (..)


type alias UpdateModel =
  { languages : List Language
  , url : Hop.Url
  }



-- TODO use reverse routing


update : Action -> UpdateModel -> ( List Language, Effects Action )
update action model =
  case Debug.log "action" action of
    Show id ->
      let
        navAction =
          navigateTo ("/languages/" ++ id)
      in
        ( model.languages, Effects.map HopAction navAction )

    Edit id ->
      let
        navAction =
          navigateTo ("/languages/" ++ id ++ "/edit")
      in
        ( model.languages, Effects.map HopAction navAction )

    Update id prop value ->
      -- need to update the language here
      let
        udpatedLanguages =
          List.map (updateWithId id prop value) model.languages
      in
        ( udpatedLanguages, Effects.none )

    AddQuery query ->
      ( model.languages, Effects.map HopAction (addQuery query model.url) )

    SetQuery query ->
      ( model.languages, Effects.map HopAction (setQuery query model.url) )

    HopAction () ->
      ( model.languages, Effects.none )


updateWithId : Id -> String -> String -> Language -> Language
updateWithId id prop value language =
  if id == language.id then
    case prop of
      "name" ->
        { language | name = value }

      _ ->
        language
  else
    language
