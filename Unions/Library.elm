module Unions.Library where

--type alias AppHandler action = (action -> String)

--type alias AppView action = (action -> String)

--type Handler action
--  = AppHandler (AppView action)
--  | TestHandler String

--testList =
--  [
--    TestHandler "Hello"
--  ]

--testApp =
--  new testList

--compare =
--  TestHandler "Hello" == TestHandler "Not Hello"

--callView

--new: List (AppView) -> List (AppView)
new: List x -> List x
new list =
  list
