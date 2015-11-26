module CallAction.App where

import CallAction.Lib as Lib
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

type Action 
  = Increment 
  | Decrement
  | LibAction Lib.Action

model = 0

--view: Signal.Address Action -> Model -> Html.Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    , button [ onClick address (LibAction Lib.DoSomething) ] [ text "Lib" ]
    ]

update action model =
  case action of
    Increment -> 
      model + 1
    Decrement -> 
      model - 1
    LibAction action ->
      lib.update action model
    _ ->
      model

lib =
  Lib.new Increment

main =
  StartApp.start { 
    model = model,
    view = view,
    update = update
  }
