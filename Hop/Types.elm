module Hop.Types (..) where

import Dict
import Task exposing (Task)


--type alias Params =
--  Dict.Dict String String
-- Move this to Url


type alias Path =
  List String



-- Move this to Url


type alias Query =
  Dict.Dict String String



-- Move this to Url


type alias Url =
  { path : Path
  , query : Query
  }



--type alias Payload = {
--    params: Params,
--    url: Url
--  }
--type alias UserPartialAction action =
--  Payload -> action
--type alias Config partialAction =
--  { notFoundAction : partialAction
--  , routes : List (RouteDefinition partialAction)
--  }
--type alias Router action =
--  { signal : Signal action
--  , payload : Payload
--  , run : Task () ()
--  }
--type alias RouteDefinition action =
--  ( String, action )
--newUrl : Url
--newUrl =
--  { query = Dict.empty
--  , path = []
--  }
--newPayload : Payload
--newPayload =
--  { params = Dict.empty
--  , url = newUrl
--  }
