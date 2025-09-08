defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> rows()
    |> extract_all_columns()
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    str
    |> rows()
    |> find_saddle_points(columns(str))
  end

  defp parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp extract_all_columns([]), do: []

  defp extract_all_columns(matrix_rows) do
    num_cols = matrix_rows |> Enum.at(0) |> length()

    0..(num_cols - 1)
    |> Enum.map(&extract_column(&1, matrix_rows))
  end

  defp find_saddle_points([], _matrix_columns), do: []

  defp find_saddle_points(matrix_rows, matrix_columns) do
    matrix_rows
    |> Enum.with_index(1)
    |> Enum.flat_map(&find_saddle_points_in_row(&1, matrix_columns))
  end

  defp find_saddle_points_in_row({row, row_index}, matrix_columns) do
    row_max = Enum.max(row)
    col_mins = Enum.map(matrix_columns, &Enum.min/1)

    row
    |> Enum.with_index(1)
    |> Enum.filter(&is_saddle_point_optimized?(&1, row_max, col_mins))
    |> Enum.map(fn {_value, col_index} -> {row_index, col_index} end)
  end

  defp is_saddle_point_optimized?({value, col_index}, row_max, col_mins) when value == row_max,
    do: value == Enum.at(col_mins, col_index - 1)

  defp is_saddle_point_optimized?(_, _, _), do: false

  defp extract_column(col_index, matrix_rows), do: Enum.map(matrix_rows, &Enum.at(&1, col_index))
end
