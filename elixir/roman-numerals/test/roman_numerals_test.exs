defmodule RomanNumeralsTest do
  use ExUnit.Case

  defmodule TestData do
    def digit_num_data() do
      %{
        # ones
        {"1", 1} => "I",
        {"2", 1} => "II",
        {"3", 1} => "III",
        {"4", 1} => "IV",
        {"5", 1} => "V",
        {"6", 1} => "VI",
        {"7", 1} => "VII",
        {"8", 1} => "VIII",
        {"9", 1} => "IX",
        {"10", 1} => "X",
        # tens
        {"1", 10} => "X",
        {"2", 10} => "XX",
        {"3", 10} => "XXX",
        {"4", 10} => "XL",
        {"5", 10} => "L",
        {"6", 10} => "LX",
        {"7", 10} => "LXX",
        {"8", 10} => "LXXX",
        {"9", 10} => "XC",
        {"10", 10} => "C",
        # hundreds
        {"1", 100} => "C",
        {"2", 100} => "CC",
        {"3", 100} => "CCC",
        {"4", 100} => "CD",
        {"5", 100} => "D",
        {"6", 100} => "DC",
        {"7", 100} => "DCC",
        {"8", 100} => "DCCC",
        {"9", 100} => "CM",
        {"10", 100} => "M",
        # thousands
        {"1", 1000} => "M",
        {"2", 1000} => "MM",
        {"3", 1000} => "MMM",
        {"4", 1000} => "MṼ",
        {"5", 1000} => "Ṽ",
        {"6", 1000} => "ṼM",
        {"7", 1000} => "ṼMM",
        {"8", 1000} => "ṼMMM",
        {"9", 1000} => "MΞ",
        {"10", 1000} => "Ξ"
      }
    end

    def numbers() do
      %{
        1 => "I",
        2 => "II",
        3 => "III",
        4 => "IV",
        5 => "V",
        6 => "VI",
        9 => "IX",
        27 => "XXVII",
        48 => "XLVIII",
        59 => "LIX",
        93 => "XCIII",
        141 => "CXLI",
        163 => "CLXIII",
        402 => "CDII",
        575 => "DLXXV",
        911 => "CMXI",
        1024 => "MXXIV",
        3000 => "MMM"
      }
    end
  end

  describe "Test (private) digit to numeral for respective position:" do
    for value = {{d, w}, v} <- TestData.digit_num_data() do
      test "position: #{w}, digit: #{d} -> #{v}" do
        {{d, w}, v} = unquote(value)
        assert RomanNumerals.digit_to_numeral(d, w) == v
      end
    end
  end

  describe "Test integer to Roman numeral conversions:" do
    for value = {i, n} <- TestData.numbers() do
      test "#{i} -> #{n}" do
        {i, n} = unquote(value)
        assert RomanNumerals.numeral(i) == n
      end
    end
  end
end
