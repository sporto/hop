module Hop.Matching exposing (..)

import String
import Hop.Types exposing (..)
import Combine exposing (parse)


{-| @priv
Matches a path (without basePath).
e.g. "/users/1/comments/2".

Returns the matching route.

    matchPathWithPathList matchers NotFound "/users/1/comments/2"

    ==

    User 1 (Comment 2)
-}
matchPathWithPathList : List (PathMatcher route) -> route -> String -> route
matchPathWithPathList routeParsers notFoundAction path =
    case routeParsers of
        [] ->
            notFoundAction

        [ routeParser ] ->
            case parse routeParser.parser path of
                ( Ok res, context ) ->
                    res

                ( Err _, context ) ->
                    notFoundAction

        routeParser :: rest ->
            case parse routeParser.parser path of
                ( Ok res, context ) ->
                    res

                ( Err _, context ) ->
                    matchPathWithPathList rest notFoundAction path


{-| @priv
Matches a path.
BasePath should already be removed.
e.g. "/users/1/comments/2".

Returns the matched route.

    matchPath config "/users/1/comments/2"

    ==

    User 1 (Comment 2)
-}
matchPath : Config route -> String -> route
matchPath config path =
    matchPathWithPathList config.matchers config.notFound path


{-| @priv
Matches a location record.
Returns the matched route.

    matchLocation config { path = ["users", "1"], query = [] }

    ==

    (User 1)
-}
matchLocation : Config route -> Location -> route
matchLocation config location =
    let
        pathString =
            String.join "/" ("" :: location.path)
    in
        matchPath config pathString
