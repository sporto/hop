import Html
import Unions.Library as Library

-- In Elm I can't compare functions
-- So it is not possible to test the library
-- by passing view functions as in the application code

-- So I want to pass just a primitive type e.g. string

view =
  "A view"

views = [
    view
  ]

library = Library.new views

compare =
  let first =
    List.head library
      |> Maybe.withDefault ""
  in
    first == view

main: Html.Html
main =
  Html.text (toString compare)

