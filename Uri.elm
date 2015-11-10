module Uri where

import String exposing (..)

type alias Url = {
  path: List String,
  hash: List String
}

-- HASH

hashPart: String -> String
hashPart str =
  let
    parts = split "#" str
    maybeFirst = List.head (List.drop 1 parts)
  in
    Maybe.withDefault "" maybeFirst

hashList: String -> List String
hashList str =
  let
    list = split "/" (hashPart str)
    notEmpty = \x -> not (isEmpty x)
  in
    List.filter notEmpty list

-- MAIN

parse: String -> Url
parse str =
  {
    path = [],
    hash = (hashList str)
  }
