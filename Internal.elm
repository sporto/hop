module Internal where

type Handler
  = AppHandler
  | TestHandler String

testList =
  [
    TestHandler "Hello"
  ]

compare =
  TestHandler "Hello" == TestHandler "Not Hello"

new: List Handler -> String
new list =
  "New"
