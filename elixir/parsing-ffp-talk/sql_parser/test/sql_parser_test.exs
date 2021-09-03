defmodule SqlParserTest do
  use ExUnit.Case
  doctest SqlParser

  test "greets the world" do
    assert SqlParser.hello() == :world
  end
end
