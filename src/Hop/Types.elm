module Hop.Types (..) where

--import Dict
--import Task exposing (Task)

import Combine exposing (Parser)


--type alias Params =
--  Dict.Dict String String
-- Move this to Url
-- Move this to Url
-- Move this to Url


type alias Route action =
  { parser : Parser action
  , segments : List String
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
