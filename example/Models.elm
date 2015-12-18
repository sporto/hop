module Example.Models where

type alias User = {
  id: String,
  name: String
}

type alias Language = {
    id: String,
    name: String,
    image: String
  }

type alias UserList = List User
