module Users.Routing.Config (..) where

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Users.Models exposing (..)


matcherUsers : PathMatcher Route
matcherUsers =
  match1 UsersRoute ""


matcherUser : PathMatcher Route
matcherUser =
  match2 UserRoute "/" int


matcherUserStatus : PathMatcher Route
matcherUserStatus =
  match3 UserStatusRoute "/" int "/edit"


matchers : List (PathMatcher Route)
matchers =
  [ matcherUsers, matcherUser, matcherUserStatus ]
