defmodule BFullTest do
  use ExUnit.Case
  # doctest App

  use Hound.Helpers

  hound_session

  defp find_title do
    find_element(:id, "title")
  end

  def assert_title(title) do
    ele = find_title()
    assert inner_html(ele) == title
  end

  def click_btn(id) do
    ele = find_element(:id, id)
    click(ele)
  end

  test "it shows home" do
    :timer.sleep(500)

    navigate_to("/app")

    source = page_source()
    IO.puts source

    assert_title("Home")
  end

  test "it shows languages" do
    :timer.sleep(500)

    navigate_to("/app/languages")
    assert_title("Languages")
  end

  test "it shows about" do
    :timer.sleep(500)

    navigate_to("/app/about")
    assert_title("About")
  end

  test "it shows a language" do
    :timer.sleep(500)

    navigate_to("/app/languages/1")
    ele = find_element(:id, "titleLanguage")
    assert inner_html(ele) == "Elm"
  end

  test "it shows the query" do
    navigate_to("/app/languages/1?typed=dynamic")
    # TODO
  end

  test "it changes the path" do
    :timer.sleep(500)

    navigate_to("/app")

    assert_title("Home")

    click_btn("btnLanguages")

    actual = execute_script("return window.location.pathname")
    assert actual == "/app/languages"
  end

  test "it changes the query" do
    :timer.sleep(500)

    navigate_to("/app/languages")

    assert_title("LanguagesFFFF")

    click_btn("btnDynamic")

    actual = execute_script("return window.location.search")
    assert actual == "?typed=dynamic"
  end

end
