defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_coins, target) when target < 0, do: {:error, "cannot change"}
  def generate(_coins, 0), do: {:ok, []}

  def generate(coins, target) do
    with {:ok, solution} <- find_minimum_coins(coins, target) do
      {:ok, Enum.sort(solution)}
    end
  end

  defp find_minimum_coins(coins, target) do
    coins
    |> build_dp_table(target)
    |> Map.get(target)
    |> handle_solution()
  end

  defp handle_solution(nil), do: {:error, "cannot change"}
  defp handle_solution(solution), do: {:ok, solution}

  defp build_dp_table(coins, target) do
    initial_table = %{0 => []}

    1..target
    |> Enum.reduce(initial_table, &find_best_solution_for_amount(coins, &1, &2))
  end

  defp find_best_solution_for_amount(coins, amount, table) do
    coins
    |> Enum.filter(&(&1 <= amount))
    |> build_candidate_solutions(amount, table)
    |> update_table_with_best_solution(table, amount)
  end

  defp build_candidate_solutions(valid_coins, amount, table) do
    Enum.flat_map(valid_coins, fn coin ->
      case Map.get(table, amount - coin) do
        nil -> []
        sub_solution -> [[coin | sub_solution]]
      end
    end)
  end

  defp update_table_with_best_solution([], table, _amount), do: table

  defp update_table_with_best_solution(solutions, table, amount) do
    best_solution = Enum.min_by(solutions, &length/1)
    Map.put(table, amount, best_solution)
  end
end
