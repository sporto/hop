# Test that navigation works as expected

defmodule NavigationTest do
	use ExUnit.Case

	use Hound.Helpers
	import TestHelpers

	hound_session

	test "navigates to home" do
		goto("/about")
		assert_title("About")

		click_on("btnHome")
		assert_title("Home")
		assert_location("/")
	end

	test "navigates to about" do
		goto("/")

		click_on("btnAbout")
		assert_title("About")
		assert_location("/about")
	end

	test "navigates to user list" do
		goto("/")

		click_on("btnUsers")
		assert_title("Users.List")
		assert_location("/users")
	end

	test "navigates to user" do
		goto("/")

		click_on("btnUser1")
		assert_title("Users.Show 1")
		assert_location("/users/1")
	end

	test "navigates to user status" do
		goto("/")

		click_on("btnUserStatus1")
		assert_title("Users.Status 1")
		assert_location("/users/1/status")
	end

end
