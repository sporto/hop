Application.ensure_all_started(:hound)
ExUnit.start()

webdriver_host = "http://#{System.get_env("WEBDRIVER_HOST")}"
webdriver_port = System.get_env("WEBDRIVER_PORT")
app_host = "http://#{System.get_env("APP_HOST")}"
app_port = System.get_env("APP_PORT")
hash = System.get_env("ROUTER_HASH")
base_path = System.get_env("ROUTER_BASEPATH")

IO.puts("=== Starting hound tests using ===")
IO.puts("webdriver_host #{webdriver_host}")
IO.puts("webdriver_port #{webdriver_port}")
IO.puts("app_host #{app_host}")
IO.puts("app_port #{app_port}")
IO.puts("hash #{hash}")
IO.puts("base_path #{base_path}")

{:ok, files} = File.ls("./test/support")

Enum.each files, fn(file) ->
	Code.require_file "support/#{file}", __DIR__
end
