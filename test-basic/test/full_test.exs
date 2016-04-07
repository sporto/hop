defmodule FullTest do
  use ExUnit.Case
  doctest Full

  use Hound.Helpers

  hound_session

  defp find_title do
    find_element(:class, "title")  
  end

  test "shows not found" do
    navigate_to("http://localhost:8000/Main.elm")

    element_id = find_element(:class, "title")

    assert inner_text(element_id) == "Not found"
  end

  test "shows main when route is main" do
    navigate_to("http://localhost:8000/Main.elm#/")

    element_id = find_element(:class, "title")

    assert inner_text(element_id) == "Main"
  end

  test "switches to view" do
    navigate_to("http://localhost:8000/Main.elm")

    btn = find_element(:class, "btnMain") 
    click(btn)
    :timer.sleep(500)

    title = find_title()
    assert inner_text(title) == "Main"
  end

end
