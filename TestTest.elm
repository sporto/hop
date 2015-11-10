module TestTest where

import String
import Graphics.Element exposing (Element)
import Uri

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

--myTest = 
--  let
--    actual = Uri.parse "foo"
--    expected = Uri.Url ["foo"]
--  in
--    test
--      "Returns the correct thing"
--      (assertEqual actual expected)

testHash =
  let
    actual = Uri.parse "#/users/1"
    expected = Uri.Url [] ["users", "1"] 
  in
    test
      "Returns path as list"
      (assertEqual expected actual)

tests : Test
tests = 
  suite "A Test Suite" 
    [ 
      --myTest,
      testHash
    ]

main : Element
main = 
    runDisplay tests
