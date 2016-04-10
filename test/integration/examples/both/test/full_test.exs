defmodule BFullTest do
  use ExUnit.Case
  # doctest App

  use Hound.Helpers

  hound_session

  test "shows initial view" do
    assert 1 == 2
  end


end
