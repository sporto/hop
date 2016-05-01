# Test that the application views match the browser location

defmodule LocationTest do
	use ExUnit.Case

	use Hound.Helpers
	import TestHelpers

	hound_session

	test "shows initial view" do
		goto("/")
		# IO.puts(current_url())
		# take_screenshot("home.png")
		assert_title("Home")
	end

	test "shows about" do
		goto("/about")
		assert_title("About")
	end

	test "shows user list" do
		# navigate_to("/Main.elm#/about")
		goto("/users")
		assert_title("Users.List")
	end

	test "shows user" do
		goto("/users/1")
		assert_title("Users.Show 1")
	end

	test "shows user" do
		goto("/users/2")
		assert_title("Users.Show 2")
	end

	test "shows user status" do
		goto("/users/1/status")
		assert_title("Users.Status 1")
	end

	test "shows to query string" do
		goto("/users?keyword=elm")
		assert_query("[(\"keyword\",\"elm\")]")
	end

	# test "switches to main view" do
	#   :timer.sleep(500)

	#   navigate_to("/Main.elm")

	#   btn = find_element(:class, "btnMain") 
	#   click(btn)
	#   :timer.sleep(500)

	#   title = find_title()
	#   # take_screenshot("./tmp/main-2.png")

	#   assert inner_html(title) == "Main"
	# end

	# test "switches to about view" do
	#   :timer.sleep(500)

	#   navigate_to("/Main.elm")

	#   btn = find_element(:class, "btnAbout") 
	#   click(btn)
	#   :timer.sleep(500)

	#   title = find_title()
	#   # take_screenshot("./tmp/main-2.png")

	#   assert inner_html(title) == "About"
	# end


	# test "switches to query string" do
	#   :timer.sleep(500)

	#   navigate_to("/Main.elm")

	#   btn = find_element(:class, "btnQuery") 
	#   click(btn)

	#   :timer.sleep(500)

	#   assert_query()
	# end


end
