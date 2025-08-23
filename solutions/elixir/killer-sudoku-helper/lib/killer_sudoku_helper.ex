defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    1..9
    |> Enum.reject(&(&1 in exclude))
    |> generate_combinations(size, sum)
    |> Enum.sort()
  end

  defp generate_combinations(available, 1, sum) do
    available
    |> Enum.filter(&(&1 == sum))
    |> Enum.map(&[&1])
  end

  defp generate_combinations(available, size, sum) do
    available
    |> Enum.flat_map(&build_combinations(&1, available, size, sum))
  end

  defp build_combinations(digit, available, size, sum) do
    available
    |> Enum.filter(&(&1 > digit))
    |> generate_combinations(size - 1, sum - digit)
    |> Enum.map(&[digit | &1])
  end
end
