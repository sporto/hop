# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# https://github.com/HashNuke/hound/blob/master/notes/configuring-hound.md

app_host = "http://#{System.get_env("APP_HOST")}"
app_port = System.get_env("APP_PORT")
webdriver_browser = System.get_env("WEBDRIVER_BROWSER")
webdriver_driver = System.get_env("WEBDRIVER_DRIVER")
webdriver_host = System.get_env("WEBDRIVER_HOST")
webdriver_port = System.get_env("WEBDRIVER_PORT")

config :hound,
	app_host: app_host,
	app_port: app_port

if webdriver_driver do
	config :hound,
		driver: webdriver_driver
end

if webdriver_browser do
	config :hound,
		browser: webdriver_browser
end

if webdriver_host do
	config :hound,
		host: "http://#{webdriver_host}"
end

if webdriver_port do
	config :hound,
		port: webdriver_port
end
