# Test that the application views match the browser location

defmodule LocationTest do
  use ExUnit.Case

  use Hound.Helpers

  hound_session

  defp assert_title(title) do
    element = find_element(:tag, "h1")
    assert inner_html(element) == title
  end

  # defp assert_query do
  #   ele = find_element(:class, "labelQuery")

  #   assert inner_html(ele) == "Dict.fromList [(\"keyword\",\"elm\")]"
  # end

  test "shows initial view" do
    :timer.sleep(200)
    navigate_to("/")
    assert_title("Home")
  end

  test "shows about" do
    :timer.sleep(200)
    navigate_to("/about")
    assert_title("About")
  end

  test "shows user list" do
    :timer.sleep(200)
    # navigate_to("/Main.elm#/about")
    navigate_to("/users")
    assert_title("Users.List")
  end

  test "shows user" do
    :timer.sleep(200)
    navigate_to("/users/1")
    assert_title("Users.Show 1")
  end

  test "shows user" do
    :timer.sleep(200)
    navigate_to("/users/2")
    assert_title("Users.Show 2")
  end

  test "shows user status" do
    :timer.sleep(200)
    navigate_to("/users/1/status")
    assert_title("Users.Status 1")
  end

  # test "shows to query string" do
  #   :timer.sleep(500)

  #   navigate_to("/Main.elm#/?keyword=elm")
  #   assert_query()
  # end

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
