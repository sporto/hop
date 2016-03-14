module Parse7 (..) where

import Html exposing (text)
import Combine exposing (..)


type UserRoute
  = Posts ()
  | Post (Int)
  | PostUser ( Int, Int )
  | NotFound


type alias Route inputs action =
  { constructor : inputs -> action
  , segments : List String
  }


route constructor segment1 =
  Route constructor [ segment1 ]


routePost =
  route Post "post"



{-
Reverse routes are easy if done manually
but how could we do the opposite?
ie. parsing a route from this?
-}


reverseRoute route (cstor inputs) =
  toString inputs


result =
  reverseRoute routePost (Post (1))


main =
  Html.div
    []
    [ Html.div [] [ Html.text (toString result) ]
    ]
