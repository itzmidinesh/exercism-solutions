defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) when number > 0 do
    numerals = [
      {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"}, {100, "C"},
      {90, "XC"}, {50, "L"}, {40, "XL"}, {10, "X"}, {9, "IX"},
      {5, "V"}, {4, "IV"}, {1, "I"}
    ]

    numeral_conversion(number, numerals, "")
  end

  defp numeral_conversion(number, [{arabic, roman} | rest], acc) do
    cond do
      number >= arabic ->
        numeral_conversion(number - arabic, [{arabic, roman} | rest], acc <> roman)
      true ->
        numeral_conversion(number, rest, acc)
    end
  end

  defp numeral_conversion(_, [], acc), do: acc
end
