defmodule Leet.HelloWorldTest do
  use ExUnit.Case
  doctest Leet.HelloWorld

  test "greets the world" do
    assert Leet.HelloWorld.hello() == :world
  end
end
