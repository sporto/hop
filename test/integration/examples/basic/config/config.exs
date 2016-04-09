# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# https://github.com/HashNuke/hound/blob/master/notes/configuring-hound.md

config :hound,
  host: "http://webdriver",
  port: 4444,
  app_host: "http://app",
  app_port: 8000
