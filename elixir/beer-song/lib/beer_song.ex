defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(0) do
    """
    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.
    """
  end

  def verse(number) when number > 0 and number <= 99 do
    {b1, minus, remaining, b2} =
      case number do
        2 -> {"bottles", "one", 1, "bottle"}
        1 -> {"bottle", "it", "no more", "bottles"}
        _ -> {"bottles", "one", number - 1, "bottles"}
      end

    ~s"""
    #{number} #{b1} of beer on the wall, #{number} #{b1} of beer.
    Take #{minus} down and pass it around, #{remaining} #{b2} of beer on the wall.
    """
  end

  def verse(number) when number < 0 or number > 99 do
    Kernel.raise(ArgumentError, "Invalid verse: #{number}, valid range: 99..0")
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    range |> Enum.map(&verse/1) |> Enum.join("\n")
  end
end
