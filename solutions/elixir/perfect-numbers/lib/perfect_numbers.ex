defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number <= 0,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(number) do
    number
    |> calculate_aliquot_sum()
    |> classify_by_sum(number)
  end

  defp classify_by_sum(sum, number) when sum == number, do: {:ok, :perfect}
  defp classify_by_sum(sum, number) when sum > number, do: {:ok, :abundant}
  defp classify_by_sum(sum, number) when sum < number, do: {:ok, :deficient}

  defp calculate_aliquot_sum(1), do: 0

  defp calculate_aliquot_sum(number) do
    1..div(number, 2)
    |> Enum.filter(&(rem(number, &1) == 0))
    |> Enum.sum()
  end
end
