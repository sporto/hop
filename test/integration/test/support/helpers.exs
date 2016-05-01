defmodule TestHelpers do
	use ExUnit.Case
	use Hound.Helpers

	def app_url do
		host = Application.get_env(:hound, :app_host)
		port = Application.get_env(:hound, :app_port)
		"#{host}:#{port}"
	end

	def using_hash do
		System.get_env("ROUTER_HASH") == "1"
	end

	def basepath do
		System.get_env("ROUTER_BASEPATH")
	end

	def using_bashpath do
		basepath && basepath != ""
	end

	def scenario do
		if using_hash do
			:hash
		else
			if using_bashpath do
				:basepath
			else
				:path
			end
		end
	end

	def wait(ms) do
		:timer.sleep(ms)
	end

	def goto(url) do
		url2 = case scenario() do
			:hash ->
				if url == "" || url == "/" do
					url
				else
					"/##{url}"
				end

			:path ->
				url

			:basepath ->
				"#{basepath}#{url}"
		end

		# IO.puts("goto #{url2}")

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

	def assert_query(query) do
		ele = find_element(:id, "locationQuery")
		assert inner_text(ele) == query
	end

	def assert_location(location) do
		# When query only:
		# /?k=a
		# /app?k=1
		# /#?k=1
		expected_location = case scenario() do
			:hash ->
				"/##{location}"

			:path ->
				location

			:basepath ->
				if location == "/" do
					"#{basepath}"
				else
					"#{basepath}#{location}"
				end
		end

		expected_location = "#{app_url}#{expected_location}"

		assert current_url() == expected_location
	end

end
