# Upgrading from 4 to 5

Version 5 works with Navigation and Elm 0.17

## Matchers

All matchers stay the same as in version 4.

## Navigation

Navigation is now handled by the Navigation module. See example app at `examples/basic/Main.elm`.
Hop doesn't return effects / commands anymore, this should be done by passing a path to `Navigation.modifyUrl`.
