defmodule FlowerField do
  @doc """
  Annotate empty spots next to flowers with the number of flowers next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate(board) do
    board
    |> Enum.with_index()
    |> Enum.map(&annotate_row(&1, board))
  end

  defp annotate_row({row, row_index}, board) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(&annotate_cell(&1, row_index, board))
    |> Enum.join()
  end

  defp annotate_cell({"*", _}, _row, _board), do: "*"
  defp annotate_cell({" ", col}, row, board), do: count_adjacent_flowers(row, col, board)

  defp count_adjacent_flowers(row, col, board) do
    neighbors(row, col)
    |> Enum.count(&flower?(&1, board))
    |> case do
      0 -> " "
      count -> Integer.to_string(count)
    end
  end

  defp neighbors(row, col) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
  end

  defp flower?({row, col}, board) when row >= 0 and col >= 0 do
    board
    |> Enum.at(row)
    |> then(&String.at(&1 || "", col)) == "*"
  end

  defp flower?(_, _), do: false
end
