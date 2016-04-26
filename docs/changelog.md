# Changelog

### 4.0.2

Futher fix for navigating to root path, use / instead of .

### 4.0.1

Fix https://github.com/sporto/hop/issues/20

## 4.0.0

- Support setState (No hashes)
- Most functions take a config record

## 3.0.0

- Typed values in routes
- Nested routes
- Reverse routing

### 2.1.1

- Remove unnecessary dependency to `elm-test`

### 2.1.0

- Expose `Query` and `Url` types

## 2.0.0

- Remove dependency on `Erl`.
- Change order of arguments on `addQuery`, `clearQuery`, `removeQuery` and `setQuery`

### 1.2.1

- Url is normalized before navigation i.e append `#/` if necessary

### 1.2.0 

- Added `addQuery`, changed behaviour of `setQuery`.

### 1.1.1

- Fixed issue where query string won't be set when no hash wash present
