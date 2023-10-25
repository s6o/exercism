defmodule PaintByNumber do
  @spec palette_bit_size(integer) :: pos_integer()
  def palette_bit_size(color_count) do
    bin_str = Integer.to_string(color_count, 2)

    sub_offset =
      if bin_str
         |> String.split("", trim: true)
         |> Enum.drop(1)
         |> Enum.all?(fn b -> b == "0" end) do
        1
      else
        0
      end

    String.length(bin_str) - sub_offset
  end

  @spec empty_picture :: bitstring()
  def empty_picture(), do: <<>>

  @spec test_picture :: bitstring()
  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  @spec prepend_pixel(bitstring, integer, integer) :: bitstring()
  def prepend_pixel(picture, color_count, pixel_color_index) do
    seg_size = palette_bit_size(color_count)
    <<pixel_color_index::size(seg_size), picture::bitstring>>
  end

  @spec get_first_pixel(bitstring, any) :: nil | pos_integer()
  def get_first_pixel(<<>>, _color_count), do: nil

  def get_first_pixel(picture, color_count) do
    seg_size = palette_bit_size(color_count)
    <<color_index::size(seg_size), _rest::bitstring>> = picture
    color_index
  end

  @spec drop_first_pixel(<<_::1, _::_*1>>, pos_integer()) :: bitstring
  def drop_first_pixel(<<>>, _color_count), do: <<>>

  def drop_first_pixel(picture, color_count) do
    seg_size = palette_bit_size(color_count)
    <<_::size(seg_size), rest::bitstring>> = picture
    rest
  end

  @spec concat_pictures(bitstring, bitstring) :: bitstring
  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>
end
