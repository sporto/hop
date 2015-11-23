import Html
import Unions.Library as Library

type Action
  = NoOp

view: Action -> String
view act =
  "Hello"

views = [
    view
  ]

-- I want to pass the views to my library
library = Library.new views

main: Html.Html
main =
  Html.text "Hi"

