module CallAction.Lib where

type Action = DoSomething

update action model =
  model + 2

new action = 
  {
    update = update
  }
