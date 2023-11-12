defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(ctx) do
      if is_bitstring(ctx) do
        e = %StackUnderflowError{}
        %{e | message: "#{e.message}, context: #{ctx}"}
      else
        %StackUnderflowError{}
      end
    end
  end

  def divide([]), do: raise(StackUnderflowError, "when dividing")
  def divide([_n]), do: raise(StackUnderflowError, "when dividing")
  def divide([0 | _]), do: raise(DivisionByZeroError)
  def divide([a, b]), do: b / a
end
