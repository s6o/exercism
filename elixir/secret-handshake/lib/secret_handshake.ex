defmodule SecretHandshake do
  use Bitwise

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    bitpos = %{
      0 => fn a, n -> bit_tr(a, n, fn a -> a ++ ["wink"] end) end,
      1 => fn a, n -> bit_tr(a, n, fn a -> a ++ ["double blink"] end) end,
      2 => fn a, n -> bit_tr(a, n, fn a -> a ++ ["close your eyes"] end) end,
      3 => fn a, n -> bit_tr(a, n, fn a -> a ++ ["jump"] end) end,
      4 => fn a, n -> bit_tr(a, n, fn a -> Enum.reverse(a) end) end
    }

    bitpos
    |> Enum.reduce({code, []}, fn {_, f}, {num, accum} -> {num >>> 1, f.(accum, num)} end)
    |> (fn {_, a} -> a end).()
  end

  defp bit_tr(accum, num, fn_tr) do
    if (num &&& 1) == 1 do
      fn_tr.(accum)
    else
      accum
    end
  end
end
