defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(rows) do
    board = parse_board(rows)

    cond do
      connected?(:black, board) -> :black
      connected?(:white, board) -> :white
      true -> :none
    end
  end

  defp parse_board(rows) do
    rows
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Map.new()
  end

  defp parse_row({row, r}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {cell, c} -> {{r, c}, cell} end)
  end

  defp connected?(:black, board) do
    cols = board |> Map.keys() |> Enum.map(&elem(&1, 1))
    starts = for {pos, "X"} <- board, elem(pos, 1) == Enum.min(cols), do: pos
    goal? = fn {_r, c} -> c == Enum.max(cols) end

    traverse(starts, board, "X", goal?)
  end

  defp connected?(:white, board) do
    rows = board |> Map.keys() |> Enum.map(&elem(&1, 0))
    starts = for {pos, "O"} <- board, elem(pos, 0) == Enum.min(rows), do: pos
    goal? = fn {r, _c} -> r == Enum.max(rows) end

    traverse(starts, board, "O", goal?)
  end

  defp traverse(starts, board, symbol, goal?) do
    starts
    |> Enum.any?(&dfs(&1, board, symbol, goal?, MapSet.new()))
  end

  defp dfs(pos, board, symbol, goal?, visited) do
    case {MapSet.member?(visited, pos), Map.get(board, pos)} do
      {false, ^symbol} -> search_from_position(pos, board, symbol, goal?, visited)
      _ -> false
    end
  end

  defp search_from_position(pos, board, symbol, goal?, visited) do
    case goal?.(pos) do
      true -> true
      false -> search_neighbors(pos, board, symbol, goal?, visited)
    end
  end

  defp search_neighbors(pos, board, symbol, goal?, visited) do
    new_visited = MapSet.put(visited, pos)

    pos
    |> neighbors()
    |> Enum.any?(&dfs(&1, board, symbol, goal?, new_visited))
  end

  defp neighbors({r, c}) do
    [{r - 1, c}, {r - 1, c + 1}, {r, c - 1}, {r, c + 1}, {r + 1, c - 1}, {r + 1, c}]
  end
end
