Application.ensure_all_started(:hound)
ExUnit.start()

hash = System.get_env("ROUTER_HASH")
base_path = System.get_env("ROUTER_BASEPATH")

IO.puts("--- Starting hound tests using ---")
IO.puts("webdriver_driver: #{Application.get_env(:hound, :driver)}")
IO.puts("webdriver_browser: #{Application.get_env(:hound, :browser)}")
IO.puts("webdriver_host: #{Application.get_env(:hound, :host)}")
IO.puts("webdriver_port: #{Application.get_env(:hound, :port)}")
IO.puts("app_host: #{Application.get_env(:hound, :app_host)}")
IO.puts("app_port: #{Application.get_env(:hound, :app_port)}")
IO.puts("hash: #{hash}")
IO.puts("base_path: #{base_path}")
IO.puts("-----------------------------------")

{:ok, files} = File.ls("./test/support")

Enum.each files, fn(file) ->
	Code.require_file "support/#{file}", __DIR__
end
