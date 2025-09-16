defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    board
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> validate_and_determine_state()
  end

  defp validate_and_determine_state(grid) do
    with x_count <- count_marks(grid, "X"),
         o_count <- count_marks(grid, "O"),
         {:ok, :valid} <- validate_turn_order(x_count, o_count),
         {:ok, :valid} <- validate_game_continuation(grid, x_count, o_count) do
      determine_game_state(grid)
    end
  end

  defp count_marks(grid, mark) do
    grid
    |> List.flatten()
    |> Enum.count(&(&1 == mark))
  end

  defp validate_turn_order(x_count, o_count) when x_count < o_count,
    do: {:error, "Wrong turn order: O started"}

  defp validate_turn_order(x_count, o_count) when x_count > o_count + 1,
    do: {:error, "Wrong turn order: X went twice"}

  defp validate_turn_order(_x_count, _o_count), do: {:ok, :valid}

  defp validate_game_continuation(grid, x_count, o_count) do
    {x_wins, o_wins} = {has_winning_line(grid, "X"), has_winning_line(grid, "O")}

    case {x_wins, o_wins, x_count - o_count} do
      {true, false, 1} -> {:ok, :valid}
      {false, true, 0} -> {:ok, :valid}
      {false, false, _} -> {:ok, :valid}
      _ -> {:error, "Impossible board: game should have ended after the game was won"}
    end
  end

  defp determine_game_state(grid) do
    case {has_winner?(grid), board_full?(grid)} do
      {true, _} -> {:ok, :win}
      {false, true} -> {:ok, :draw}
      {false, false} -> {:ok, :ongoing}
    end
  end

  defp has_winner?(grid), do: has_winning_line(grid, "X") or has_winning_line(grid, "O")

  defp has_winning_line(grid, mark),
    do: rows_win?(grid, mark) or columns_win?(grid, mark) or diagonals_win?(grid, mark)

  defp rows_win?(grid, mark), do: Enum.any?(grid, &all_cells_match?(&1, mark))

  defp all_cells_match?(row, mark), do: Enum.all?(row, &(&1 == mark))

  defp columns_win?(grid, mark) do
    [0, 1, 2]
    |> Enum.any?(&column_wins?(grid, &1, mark))
  end

  defp column_wins?(grid, column_index, mark) do
    [0, 1, 2]
    |> Enum.all?(&(get_cell(grid, &1, column_index) == mark))
  end

  defp get_cell(grid, row, col), do: grid |> Enum.at(row) |> Enum.at(col)

  defp diagonals_win?(grid, mark),
    do: main_diagonal_wins?(grid, mark) or anti_diagonal_wins?(grid, mark)

  defp main_diagonal_wins?(grid, mark) do
    [{0, 0}, {1, 1}, {2, 2}]
    |> Enum.all?(fn {row, col} -> get_cell(grid, row, col) == mark end)
  end

  defp anti_diagonal_wins?(grid, mark) do
    [{0, 2}, {1, 1}, {2, 0}]
    |> Enum.all?(fn {row, col} -> get_cell(grid, row, col) == mark end)
  end

  defp board_full?(grid) do
    grid
    |> List.flatten()
    |> Enum.all?(&(&1 != "."))
  end
end
