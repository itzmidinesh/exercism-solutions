defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []

  def matrix(dimension) do
    matrix = for _ <- 1..dimension, do: :lists.duplicate(dimension, 0)
    fill_matrix(matrix, 1, {0, 0}, :right, dimension)
  end

  defp fill_matrix(matrix, current, _, _, dimension) when current > dimension * dimension,
    do: matrix

  defp fill_matrix(matrix, current, {row, column}, direction, dimension) do
    matrix =
      List.update_at(matrix, row, fn row ->
        List.update_at(row, column, fn _ -> current end)
      end)

    {new_direction, {new_row, new_column}} =
      next_position({row, column}, direction, matrix, dimension)

    fill_matrix(matrix, current + 1, {new_row, new_column}, new_direction, dimension)
  end

  defp next_position({row, column}, :right, matrix, dimension) do
    if column + 1 < dimension && Enum.at(Enum.at(matrix, row), column + 1) == 0 do
      {:right, {row, column + 1}}
    else
      {:down, {row + 1, column}}
    end
  end

  defp next_position({row, column}, :down, matrix, dimension) do
    if row + 1 < dimension && Enum.at(Enum.at(matrix, row + 1), column) == 0 do
      {:down, {row + 1, column}}
    else
      {:left, {row, column - 1}}
    end
  end

  defp next_position({row, column}, :left, matrix, _dimension) do
    if column - 1 >= 0 && Enum.at(Enum.at(matrix, row), column - 1) == 0 do
      {:left, {row, column - 1}}
    else
      {:up, {row - 1, column}}
    end
  end

  defp next_position({row, column}, :up, matrix, _dimension) do
    if row - 1 >= 0 && Enum.at(Enum.at(matrix, row - 1), column) == 0 do
      {:up, {row - 1, column}}
    else
      {:right, {row, column + 1}}
    end
  end
end
