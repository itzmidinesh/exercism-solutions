defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_number_string, size) when size < 0 do
    raise ArgumentError, "Span size must be a non-negative integer."
  end

  def largest_product(_number_string, 0), do: 1

  def largest_product(number_string, size) when size > byte_size(number_string) do
    raise ArgumentError, "Span size cannot be greater than the length of the string."
  end

  def largest_product(number_string, size) do
    with {:ok, digits} <- validate_and_parse_digits(number_string) do
      digits
      |> Stream.chunk_every(size, 1, :discard)
      |> Stream.map(&multiply_digits/1)
      |> Enum.max()
    end
  end

  @spec validate_and_parse_digits(String.t()) :: {:ok, [non_neg_integer]} | {:error, String.t()}
  defp validate_and_parse_digits(number_string) do
    if String.match?(number_string, ~r/^\d*$/) do
      digits =
        number_string
        |> String.to_charlist()
        |> Enum.map(&(&1 - ?0))

      {:ok, digits}
    else
      raise ArgumentError, "Input must contain only digits."
    end
  end

  @spec multiply_digits([non_neg_integer]) :: non_neg_integer
  defp multiply_digits(digits), do: Enum.reduce(digits, 1, &*/2)
end
