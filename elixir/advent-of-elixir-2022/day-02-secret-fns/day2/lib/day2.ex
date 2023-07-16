defmodule Day2 do
  def exported, do: private()
  defp private, do: :ok
end

defmodule Day2Attr do
  defstruct [:first, second: :atom]

  # Sticky attribute
  Module.register_attribute(__MODULE__, :sticky_attribute, persist: true)
  # Compile time only attribute
  @some_attribute "hello"
  def use_attribute, do: @some_attribute

  defmacro some_marcro, do: :ok
end
