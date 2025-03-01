defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate([]), do: []
  def annotate([""]), do: [""]

  def annotate(board) do
    rows = length(board)
    cols = String.length(hd(board))

    board
    |> validate_board(cols)
    |> process_board(rows, cols)
  end

  defp validate_board(board, cols) do
    Enum.each(board, fn row ->
      if String.length(row) != cols do
        raise ArgumentError, "Invalid board: rows have different lengths."
      end
    end)

    board
  end

  defp process_board(board, rows, cols) do
    board
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      String.graphemes(row)
      |> Enum.with_index()
      |> Enum.map(fn {cell, col_index} ->
        if cell == "*" do
          "*"
        else
          count_mines(board, row_index, col_index, rows, cols)
        end
      end)
    end)
    |> Enum.chunk_every(cols)
    |> Enum.map(&Enum.join/1)
  end

  defp count_mines(board, row, col, rows, cols) do
    for i <- max(row - 1, 0)..min(row + 1, rows - 1),
        j <- max(col - 1, 0)..min(col + 1, cols - 1),
        i != row or j != col,
        String.at(Enum.at(board, i), j) == "*",
        reduce: 0 do
      count -> count + 1
    end
    |> case do
      0 -> " "
      count -> Integer.to_string(count)
    end
  end
end
