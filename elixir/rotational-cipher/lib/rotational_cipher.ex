defmodule RotationalCipher do
  @alphabet "abcdefghijklmnopqrstuvwxyz"
  @cipher_length String.length(@alphabet)

  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> String.split(~r{.}, include_captures: true, trim: true)
    |> Enum.map_join(fn ch -> encode(ch, shift) end)
  end

  defp encode(letter, shift) do
    search = String.downcase(letter)

    case :binary.match(@alphabet, search) do
      :nomatch ->
        letter

      {pos, _} ->
        encoded = String.slice(@alphabet, Kernel.rem(pos + shift, @cipher_length), 1)
        if letter == search, do: encoded, else: String.upcase(encoded)
    end
  end
end
