defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    if valid_input?(number) do
      number
      |> to_charlist()
      |> Enum.filter(&(&1 in ?0..?9))
      |> Enum.map(&Integer.parse(<<&1>>))
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {{number, _}, index} -> double_digits(number, index) end)
      |> Enum.sum()
      |> rem(10) == 0
    else
      false
    end
  end

  defp double_digits(number, index) when rem(index, 2) == 0, do: number

  defp double_digits(number, index) when rem(index, 2) == 1 do
    double = number * 2
    if double > 9, do: double - 9, else: double
  end

  defp valid_input?(number) do
    case String.replace(number, " ", "") do
      "0" ->
        false

      _ ->
        0 ==
          number
          |> to_charlist()
          |> Enum.drop_while(&(&1 in ?0..?9 || &1 == ?\s))
          |> Enum.count()
    end
  end
end
