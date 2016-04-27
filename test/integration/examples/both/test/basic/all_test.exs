defmodule BasicTest do
  use ExUnit.Case
  # doctest App

  use Hound.Helpers

  hound_session

  defp find_title do
    find_element(:class, "title")  
  end

  defp find_query do
    find_element(:class, "labelQuery")
  end

  defp assert_query do
    ele = find_element(:class, "labelQuery")

    assert inner_html(ele) == "Dict.fromList [(\"keyword\",\"elm\")]"
  end

  test "shows initial view" do
    :timer.sleep(500)

    navigate_to("/Main.elm")

    # take_screenshot("./tmp/not-found.png")
    element_id = find_element(:class, "title")

    assert inner_html(element_id) == "Main"
  end

  test "shows main when route is main" do
    :timer.sleep(500)

    navigate_to("/Main.elm#/")

    element_id = find_element(:class, "title")
    # take_screenshot("./tmp/main.png")

    assert inner_html(element_id) == "Main"
  end

  test "shows about when route is about" do
    :timer.sleep(500)

    navigate_to("/Main.elm#/about")

    element_id = find_element(:class, "title")

    assert inner_html(element_id) == "About"
  end

  test "shows to query string" do
    :timer.sleep(500)

    navigate_to("/Main.elm#/?keyword=elm")
    assert_query()
  end

  test "switches to main view" do
    :timer.sleep(500)

    navigate_to("/Main.elm")

    btn = find_element(:class, "btnMain") 
    click(btn)
    :timer.sleep(500)

    title = find_title()
    # take_screenshot("./tmp/main-2.png")

    assert inner_html(title) == "Main"
  end

  test "switches to about view" do
    :timer.sleep(500)

    navigate_to("/Main.elm")

    btn = find_element(:class, "btnAbout") 
    click(btn)
    :timer.sleep(500)

    title = find_title()
    # take_screenshot("./tmp/main-2.png")

    assert inner_html(title) == "About"
  end


  test "switches to query string" do
    :timer.sleep(500)

    navigate_to("/Main.elm")

    btn = find_element(:class, "btnQuery") 
    click(btn)

    :timer.sleep(500)

    assert_query()
  end


end
