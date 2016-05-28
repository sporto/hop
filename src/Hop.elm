module Hop exposing (matchUrl, matcherToPath, getUrl)

{-| Navigation and routing utilities for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Create URLs
@docs getUrl

# Match current URL
@docs matchUrl

# Reverse Routing
@docs matcherToPath

-}


import String
import Hop.Types exposing (..)
import Hop.Location
import Hop.Matching exposing (..)


---------------------------------------
-- MATCHING
---------------------------------------

matchUrl : Config route -> String -> (route, Hop.Types.Location)
matchUrl config url =
  let
    location =
      Hop.Location.fromUrl config url
  in
    (matchLocation config location, location)


{-|
Generates a path from a matcher. Use this for reverse routing.

The last parameters is a list of strings. You need to pass one string for each dynamic parameter that this route takes.

    matcherToPath bookReviewMatcher ["1", "2"]

    ==

    "/books/1/reviews/2"
-}
matcherToPath : PathMatcher a -> List String -> String
matcherToPath matcher inputs =
  let
    inputs' =
      List.append inputs [ "" ]

    makeSegment segment input =
      segment ++ input

    path =
      List.map2 makeSegment matcher.segments inputs'
        |> String.join ""
  in
    path


---------------------------------------
-- UTILS
---------------------------------------


{-| Create a url from ...

  navigateTo will append "#/" if necessary

    navigateTo config "/users"

  Example use in update:

    update action model =
      case action of
        ...
        NavigateTo path ->
          (model, Effects.map HopAction (navigateTo config path))
-}
getUrl : Config route -> String -> String
getUrl config route =
    route
        |> Hop.Location.locationFromUser
        |> getUrlFromLocation config


{-| @private
Create an url from a location
-}
getUrlFromLocation : Config route -> Location -> String
getUrlFromLocation config location =
    let
        fullPath =
            Hop.Location.locationToFullPath config location

        path =
            if fullPath == "" then
                "/"
            else
                fullPath
    in
        path
