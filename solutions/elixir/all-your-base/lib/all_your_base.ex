defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, input_base, _) when input_base <2, do: {:error, "input base must be >= 2"}
  def convert(_, _, output_base) when output_base <2, do: {:error, "output base must be >= 2"}
  def convert(digits, input_base, output_base) do
    if valid_digits?(digits, input_base) do
      {:error, "all digits must be >= 0 and < input base"}
    else
      result = digits
      |> from_base(input_base)
      |> to_base(output_base, [])
      {:ok, result}
    end
  end
  defp valid_digits?(digits, input_base) do
    Enum.any?(digits, &(&1 < 0 or &1 >= input_base))
  end
  defp from_base(digits, input_base) do
    Enum.reduce(digits, 0, fn digit, acc -> acc * input_base + digit end)
  end
  defp to_base(0, _, []), do: [0]
  defp to_base(0, _, acc), do: acc
  defp to_base(number, output_base, acc) do
    div = div(number, output_base)
    rem = rem(number, output_base)
    to_base(div, output_base, [rem | acc])
  end
end
