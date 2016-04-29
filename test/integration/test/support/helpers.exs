defmodule TestHelpers do
	use ExUnit.Case
	use Hound.Helpers

	def hash do
		System.get_env("ROUTER_HASH")
	end

	def base_path do
		System.get_env("ROUTER_BASEPATH")
	end

	def wait(ms) do
		:timer.sleep(ms)
	end

	def goto(url) do
		url2 = if hash == "1" do
			if url == "" || url == "/" do
				url
			else
				"/##{url}"
			end
		else
			if base_path == "" do
				url
			else
				"#{base_path}#{url}"
			end
		end

		# IO.puts("url #{url2}")
		navigate_to(url2)
		:timer.sleep(100)
	end

	def click_on(id) do
		btn = find_element(:id, id) 
		click(btn)
		:timer.sleep(200)
	end

	def assert_title(title) do
		element = find_element(:tag, "h1")
		assert inner_html(element) == title
	end

end
