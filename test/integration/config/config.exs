# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# https://github.com/HashNuke/hound/blob/master/notes/configuring-hound.md

config :hound,
  browser: "chrome",
  host: "http://#{System.get_env("WEBDRIVER_HOST")}",
  port: System.get_env("WEBDRIVER_PORT"),
  app_host: "http://#{System.get_env("APP_HOST")}",
  app_port: System.get_env("APP_PORT")
