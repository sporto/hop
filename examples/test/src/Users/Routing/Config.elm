module Users.Routing.Config (..) where

import Hop.Types exposing (PathMatcher)
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
  match3 UserStatusRoute "/" int "/status"


matchers : List (PathMatcher Route)
matchers =
  [ matcherUsers, matcherUser, matcherUserStatus ]
