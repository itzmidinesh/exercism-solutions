defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0 or number > 999_999_999_999,
    do: {:error, "number is out of range"}

  def in_english(0), do: {:ok, "zero"}
  def in_english(number), do: {:ok, convert_number(number)}

  defp convert_number(number) when number < 20, do: ones(number)

  defp convert_number(number) when number < 100,
    do: combine_tens_ones(div(number, 10), rem(number, 10))

  defp convert_number(number) when number < 1000,
    do: combine_hundreds(div(number, 100), rem(number, 100))

  defp convert_number(number) when number < 1_000_000,
    do: convert_with_scale(number, 1000, "thousand")

  defp convert_number(number) when number < 1_000_000_000,
    do: convert_with_scale(number, 1_000_000, "million")

  defp convert_number(number),
    do: convert_with_scale(number, 1_000_000_000, "billion")

  defp convert_with_scale(number, divisor, scale_word),
    do: combine_with_scale(div(number, divisor), rem(number, divisor), scale_word)

  defp combine_tens_ones(tens_digit, 0), do: tens(tens_digit)
  defp combine_tens_ones(tens_digit, ones_digit), do: tens(tens_digit) <> "-" <> ones(ones_digit)

  defp combine_hundreds(hundreds_digit, 0), do: ones(hundreds_digit) <> " hundred"

  defp combine_hundreds(hundreds_digit, remainder),
    do: ones(hundreds_digit) <> " hundred " <> convert_number(remainder)

  defp combine_with_scale(quotient, 0, scale_word),
    do: convert_number(quotient) <> " " <> scale_word

  defp combine_with_scale(quotient, remainder, scale_word),
    do: convert_number(quotient) <> " " <> scale_word <> " " <> convert_number(remainder)

  defp ones(1), do: "one"
  defp ones(2), do: "two"
  defp ones(3), do: "three"
  defp ones(4), do: "four"
  defp ones(5), do: "five"
  defp ones(6), do: "six"
  defp ones(7), do: "seven"
  defp ones(8), do: "eight"
  defp ones(9), do: "nine"
  defp ones(10), do: "ten"
  defp ones(11), do: "eleven"
  defp ones(12), do: "twelve"
  defp ones(13), do: "thirteen"
  defp ones(14), do: "fourteen"
  defp ones(15), do: "fifteen"
  defp ones(16), do: "sixteen"
  defp ones(17), do: "seventeen"
  defp ones(18), do: "eighteen"
  defp ones(19), do: "nineteen"

  defp tens(2), do: "twenty"
  defp tens(3), do: "thirty"
  defp tens(4), do: "forty"
  defp tens(5), do: "fifty"
  defp tens(6), do: "sixty"
  defp tens(7), do: "seventy"
  defp tens(8), do: "eighty"
  defp tens(9), do: "ninety"
end
