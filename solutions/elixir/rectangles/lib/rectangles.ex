defmodule Rectangles do
  @doc """
  Count the number of ASCII rectangles.
  """
  @spec count(input :: String.t()) :: integer
  def count(""), do: 0

  def count(input) do
    grid = parse_grid(input)

    grid
    |> find_corners()
    |> generate_corner_pairs()
    |> Enum.count(&valid_rectangle?(&1, grid))
  end

  defp parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Map.new()
  end

  defp parse_row({line, row}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, col} -> {{row, col}, char} end)
  end

  defp find_corners(grid) do
    grid
    |> Enum.filter(&corner?/1)
    |> Enum.map(&elem(&1, 0))
  end

  defp corner?({_pos, "+"}), do: true
  defp corner?(_), do: false

  defp generate_corner_pairs(corners) do
    corners
    |> Enum.flat_map(&find_valid_pairs(&1, corners))
  end

  defp find_valid_pairs({r1, c1} = top_left, corners) do
    corners
    |> Enum.filter(fn {r2, c2} -> r1 < r2 and c1 < c2 end)
    |> Enum.map(fn bottom_right -> {top_left, bottom_right} end)
  end

  defp valid_rectangle?({{r1, c1}, {r2, c2}}, grid) do
    [
      validate_all_corners_exist?([{r1, c1}, {r1, c2}, {r2, c1}, {r2, c2}], grid),
      validate_horizontal_sides?(r1, r2, c1, c2, grid),
      validate_vertical_sides?(r1, r2, c1, c2, grid)
    ]
    |> Enum.all?()
  end

  defp validate_all_corners_exist?(corners, grid) do
    corners
    |> Enum.all?(fn pos -> Map.get(grid, pos) == "+" end)
  end

  defp validate_horizontal_sides?(r1, r2, c1, c2, grid) do
    [r1, r2]
    |> Enum.all?(&validate_horizontal_line?(&1, c1, c2, grid))
  end

  defp validate_vertical_sides?(r1, r2, c1, c2, grid) do
    [c1, c2]
    |> Enum.all?(&validate_vertical_line?(&1, r1, r2, grid))
  end

  defp validate_horizontal_line?(row, col1, col2, grid) do
    col1..col2
    |> Enum.map(fn col -> {row, col} end)
    |> validate_line?(["+", "-"], grid)
  end

  defp validate_vertical_line?(col, row1, row2, grid) do
    row1..row2
    |> Enum.map(fn row -> {row, col} end)
    |> validate_line?(["+", "|"], grid)
  end

  defp validate_line?(positions, valid_chars, grid) do
    positions
    |> Enum.all?(fn pos ->
      char = Map.get(grid, pos)
      char in valid_chars
    end)
  end
end
