defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist(), char()) :: non_neg_integer()
  def count(strand, nucleotide) do
    histogram(strand) |> Map.get(nucleotide, 0)
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist()) :: map()
  def histogram(strand) do
    strand
    |> Enum.reduce(%{?A => 0, ?C => 0, ?G => 0, ?T => 0}, fn c, accum ->
      if Enum.member?(@nucleotides, c) do
        {_, accum} = Map.get_and_update!(accum, c, fn v -> {v, v + 1} end)
        accum
      else
        accum
      end
    end)
  end
end
