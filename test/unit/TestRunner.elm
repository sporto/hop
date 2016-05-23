module Main exposing (..)

import ElmTest
import Tests

main =
  ElmTest.runSuite Tests.all
