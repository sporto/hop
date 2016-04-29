# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# https://github.com/HashNuke/hound/blob/master/notes/configuring-hound.md

webdriver_host = "http://#{System.get_env("WEBDRIVER_HOST")}"
webdriver_port = System.get_env("WEBDRIVER_PORT")
app_host = "http://#{System.get_env("APP_HOST")}"
app_port = System.get_env("APP_PORT")

config :hound,
	browser: "chrome",
	host: webdriver_host,
	port: webdriver_port,
	app_host: app_host,
	app_port: app_port
