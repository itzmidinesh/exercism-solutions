defmodule GameOfLife do
  @doc """
  Apply the rules of Conway's Game of Life to a grid of cells
  """

  @neighbor_offsets [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  @spec tick(matrix :: list(list(0 | 1))) :: list(list(0 | 1))
  def tick([]), do: []

  def tick(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.map(&process_row(&1, matrix))
  end

  defp process_row({row, row_idx}, matrix) do
    row
    |> Enum.with_index()
    |> Enum.map(&process_cell(&1, matrix, row_idx))
  end

  defp process_cell({cell, col_idx}, matrix, row_idx) do
    @neighbor_offsets
    |> Enum.map(&neighbor_position(&1, row_idx, col_idx))
    |> Enum.map(&get_cell_safe(matrix, &1))
    |> Enum.sum()
    |> apply_rules(cell)
  end

  defp neighbor_position({row_offset, col_offset}, row, col),
    do: {row + row_offset, col + col_offset}

  defp get_cell_safe(_matrix, {row, col}) when row < 0 or col < 0, do: 0

  defp get_cell_safe(matrix, {row, col}),
    do: get_in(matrix, [Access.at(row), Access.at(col)]) || 0

  defp apply_rules(2, 1), do: 1
  defp apply_rules(3, 1), do: 1
  defp apply_rules(3, 0), do: 1
  defp apply_rules(_, _), do: 0
end
