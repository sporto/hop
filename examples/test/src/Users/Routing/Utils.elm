module Users.Routing.Utils exposing (..)

import Hop exposing (matcherToPath)
import Users.Models exposing (..)
import Users.Routing.Config exposing (..)


toS : a -> String
toS =
    toString


reverseWithPrefix : Route -> String
reverseWithPrefix route =
    "/languages" ++ (reverse route)


reverse : Route -> String
reverse route =
    case route of
        UsersRoute ->
            matcherToPath matcherUsers []

        UserRoute id ->
            matcherToPath matcherUser [ toS id ]

        UserStatusRoute id ->
            matcherToPath matcherUserStatus [ toS id ]

        NotFoundRoute ->
            ""
