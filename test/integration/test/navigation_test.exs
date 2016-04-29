# Test that navigation works as expected

defmodule NavigationTest do
	use ExUnit.Case

	use Hound.Helpers
	import TestHelpers

	hound_session

	test "navigates to about" do
		:timer.sleep(200)
		navigate_to("/")
		click_on("btnAbout")
		assert_title("About")
	end

	test "navigates to user list" do
		:timer.sleep(200)
		navigate_to("/")
		click_on("btnUsers")
		assert_title("Users.List")
	end

	test "navigates to user" do
		:timer.sleep(200)
		navigate_to("/")
		click_on("btnUser1")
		assert_title("Users.Show 1")
	end

	test "navigates to user status" do
		:timer.sleep(200)
		navigate_to("/")
		click_on("btnUserStatus1")
		assert_title("Users.Status 1")
	end

end
