defmodule FullTest do
  use ExUnit.Case
  doctest Full

  use Hound.Helpers

  hound_session

  defp find_title do
    find_element(:class, "title")  
  end

  test "shows not found" do
    navigate_to("/Main.elm")

    take_screenshot("./tmp/not-found.png")
    element_id = find_element(:class, "title")

    assert inner_html(element_id) == "Not found"
  end

  test "shows main when route is main" do
    navigate_to("/Main.elm#/")

    element_id = find_element(:class, "title")
    # take_screenshot("./tmp/main.png")

    assert inner_html(element_id) == "Main"
  end

  test "switches to view" do
    navigate_to("/Main.elm")

    btn = find_element(:class, "btnMain") 
    click(btn)
    :timer.sleep(500)

    title = find_title()
    take_screenshot("./tmp/main-2.png")

    assert inner_html(title) == "Main"
  end

end
