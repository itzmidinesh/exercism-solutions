defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    factors
    |> Enum.flat_map(fn factor -> multiples_below(limit, factor) end)
    |> Enum.uniq()
    |> Enum.sum()
  end

  defp multiples_below(_limit, 0), do: []
  defp multiples_below(limit, factor), do: Enum.filter(1..(limit - 1), &(rem(&1, factor) == 0))
end
