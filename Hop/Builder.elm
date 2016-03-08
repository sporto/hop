module Hop.Builder (..) where

--import Hop.Types exposing (..)

import Dict


type alias Query =
  Dict.Dict String String



--type PathParam
--  = String
--  | Int
--type Route action
--  = Route' action Path1 (List Route)
--type Segment
--  = Path1 String
--  | Segment2 String SegmentParam
--  | Segment3 String SegmentParam String
--type alias Path1 = {
--  }
--type Path
--  = Path1 String
--type Route1 action
--  = Route1 action Path1 (List Route)
--type Route actionCreator subActionCreator
--  = Route actionCreator Path (List (Route subActionCreator))
--type RouteType actionCreator
--  = Route String actionCreator (Routes ())
--
--type alias Route actionCreator =
--  { path : String
--  , actionCreator : actionCreator
--  , subRoutes : List Route
--  }


type RouteClass actionCreator subActionCreator
  = Route String actionCreator
  | ParentRoute String (Query -> subActionCreator -> actionCreator) (List subActionCreator)



--type alias Routes actionCreator =
--  List (Route actionCreator)
--type Routes actionCreator
-- = Routes
--type RouteCreator
--path : String -> Path
--path segment =
--  Path1 segment
--int : PathParam
--int =
--  Int
-- actionCreator = (Query -> action)
--route : String -> (subAction -> actionCreator) -> Routes subAction -> Route actionCreator subAction
--route : String -> (Query -> action) -> Routes b -> Route (Query -> action)
--route path actionCreator subRoutes =
--  Route path actionCreator subRoutes
--group : actionCreator -> Path -> Routes actionCreator -> Route actionCreator


match : String -> String
match path =
  "HEllo"



--match : List (Route action) -> String -> action
--match routes path =
--  ""
--route1 : (a -> r) -> Path1 -> List Route -> Route
--route1 actionCreator path subRoutes =
--  ""
