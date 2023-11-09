defmodule DNA do
  def encode_nucleotide(?\s), do: 0
  def encode_nucleotide(?A), do: 1
  def encode_nucleotide(?C), do: 2
  def encode_nucleotide(?G), do: 4
  def encode_nucleotide(?T), do: 8

  def decode_nucleotide(0b0000), do: ?\s
  def decode_nucleotide(0b0001), do: ?A
  def decode_nucleotide(0b0010), do: ?C
  def decode_nucleotide(0b0100), do: ?G
  def decode_nucleotide(0b1000), do: ?T

  def encode(dna), do: do_encode(dna, <<>>)

  defp do_encode([], accum), do: accum

  defp do_encode([c | rest], accum),
    do: do_encode(rest, <<accum::bitstring, encode_nucleotide(c)::size(4)>>)

  def decode(dna), do: do_decode(dna, [])

  defp do_decode(<<>>, accum), do: accum

  defp do_decode(<<nuc::size(4), rest::bitstring>>, accum),
    do: do_decode(rest, accum ++ [decode_nucleotide(nuc)])
end
