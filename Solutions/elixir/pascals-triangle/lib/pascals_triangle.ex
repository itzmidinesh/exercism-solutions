defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(0), do: []
  def rows(1), do: [[1]]

  def rows(num) do
    1..(num - 1)
    |> Enum.scan([1], fn _, prev_row -> next_row(prev_row) end)
    |> List.insert_at(0, [1])
  end

  defp next_row(prev_row) do
    [0 | prev_row]
    |> Enum.zip(prev_row ++ [0])
    |> Enum.map(fn {a, b} -> a + b end)
  end
end
