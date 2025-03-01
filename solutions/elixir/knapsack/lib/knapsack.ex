defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value(items, maximum_weight) do
    solve_knapsack(items, maximum_weight, length(items))
  end

  defp solve_knapsack(_, 0, _), do: 0
  defp solve_knapsack([], _, _), do: 0

  defp solve_knapsack([%{weight: w, value: v} | tail], max_weight, n) do
    if w > max_weight do
      solve_knapsack(tail, max_weight, n - 1)
    else
      max(
        v + solve_knapsack(tail, max_weight - w, n - 1),
        solve_knapsack(tail, max_weight, n - 1)
      )
    end
  end
end
