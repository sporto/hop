# Upgrading from 3 to 4

Version 4 introduces push state. There are two major changes:

## Config

Config now includes `hash` and `basePath`.

```elm
routerConfig : Config Route
routerConfig =
  { hash = True
  , basePath = ""
  , matchers = matchers
  , notFound = NotFoundRoute
  }
```

## Functions require the router config

Most functions in Hop now require your router config. For example instead of:

```elm
navigateTo path
addQuery query location
```

It is now:

```elm
navigateTo config path
addQuery config query location
```

This is because Hop needs to know if you are using hash or path routing.
