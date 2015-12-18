module Example.Models where

type alias User = {
  id: String,
  name: String
}

type alias Language = {
    id: String,
    name: String,
    image: String,
    tags: List String
  }

type alias UserList = List User

languages : List Language
languages =
  [
    {
      id = "1",
      name = "Elm",
      image = "elm",
      tags = ["functional"]
    },
    {
      id = "2",
      name = "JavaScript",
      image = "js",
      tags = ["functional", "oo"]
    },
    {
      id = "3",
      name = "Go",
      image = "go",
      tags = ["oo"]
    },
    {
      id = "4",
      name = "Rust",
      image = "rust",
      tags = ["functional"]
    },
    {
      id = "5",
      name = "Elixir",
      image = "elixir",
      tags = ["functional"]
    },
    {
      id = "6",
      name = "Ruby",
      image = "ruby",
      tags = ["oo"]
    },
    {
      id = "7",
      name = "Python",
      image = "python",
      tags = ["oo"]
    },
    {
      id = "8",
      name = "Swift",
      image = "swift",
      tags = ["functional"]
    },
    {
      id = "9",
      name = "Haskell",
      image = "haskell",
      tags = ["functional"]
    },
    {
      id = "10",
      name = "Java",
      image = "java",
      tags = ["oo"]
    },
    {
      id = "11",
      name = "C#",
      image = "csharp",
      tags = ["oo"]
    },
    {
      id = "12",
      name = "PHP",
      image = "php",
      tags = ["oo"]
    }
  ]
