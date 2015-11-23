-- Somehow Internal needs to use a type from here
import Html
import Internal

type Action
  = NoOp

view1: Action -> String
view1 act =
  "Hello"

view2: Action -> String
view2 act = 
  "Hi"

list = [
    view1
  ]

foo =
  Internal.new list

main: Html.Html
main =
  Html.text (toString Internal.compare)

