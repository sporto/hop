module Users.Models exposing (..)

-- ROUTING


type alias User =
    { id : Int
    }


type Route
    = UsersRoute
    | UserRoute Int
    | UserStatusRoute Int
    | NotFoundRoute
