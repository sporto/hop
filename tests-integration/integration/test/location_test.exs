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

	test "shows user 1" do
		goto("/users/1")
		assert_title("Users.Show 1")
	end

	test "shows user 2" do
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

end
