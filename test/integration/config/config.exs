# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# https://github.com/HashNuke/hound/blob/master/notes/configuring-hound.md

webdriver_host = System.get_env("WEBDRIVER_HOST")  || "localhost"
webdriver_port = System.get_env("WEBDRIVER_PORT") || "4444"
app_host = "http://#{System.get_env("APP_HOST")}"
app_port = System.get_env("APP_PORT")
browser = System.get_env("WEBDRIVER_BROWSER") || "chrome"


# webdriver_host = if webdriver_host == "" do
# 		"localhost"
# 	else
# 		webdriver_host
# end

webdriver_host = "http://#{webdriver_host}"
# IO.puts("host #{webdriver_host}")

config :hound,
	driver: "selenium",
	browser: browser,
	host: webdriver_host,
	port: webdriver_port,
	app_host: app_host,
	app_port: app_port
